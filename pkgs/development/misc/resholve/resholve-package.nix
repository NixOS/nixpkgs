{ stdenv, lib, resholve }:

{ pname
, src
, version
, passthru ? { }
  # resholve-specific API
  # paths to try resolving
, scripts
  # packages to resolve executables from
, inputs
, interpreter
  # see resholve docs for semantics, but fake/fix/keep are all
  # key: [list] mapped to key:value2;value2
, fake ? { }
, fix ? { }
, keep ? { }
  # file to inject before first code-line of script
, prologue ? false
  # file to inject after last code-line of script
, epilogue ? false
  # extra command-line flags passed to resholve; generally the API here
  # should align with what resholve supports, but flags is helpful if you
  # need to override the version of resholve in use.
, flags ? [ ]
, ...
}@attrs:
let
  inherit stdenv;
  self = (stdenv.mkDerivation ((removeAttrs attrs [ "scripts" "inputs" "interpreter" "fake" "fix" "keep" "prologue" "epilogue" "flags" ])
    // {
    inherit pname version src;
    buildInputs = [ resholve ];
    RESHOLVE_PATH = "${lib.makeBinPath inputs}";
    RESHOLVE_INTERPRETER = interpreter;
    RESHOLVE_FAKE =
      toString (lib.mapAttrsToList (name: value: map (y: name + ":" + y) value) fake);
    RESHOLVE_FIX =
      toString (lib.mapAttrsToList (name: value: if (!builtins.isList value || builtins.length value == 0) then name else (map (y: name + ":" + y) value)) fix);
    RESHOLVE_KEEP =
      toString (lib.mapAttrsToList (name: value: if (!builtins.isList value || builtins.length value == 0) then name else (map (y: name + ":" + y) value)) keep);
    RESHOLVE_PROLOGUE = stdenv.lib.optionalString prologue prologue;
    RESHOLVE_EPILOGUE = stdenv.lib.optionalString epilogue epilogue;
    #LOGLEVEL="INFO";
    # intentionally not stripping RESHOLVE_PATH or
    # RESHOLVE_INTERPRETER even empty; required arguments.
    preFixup = ''
      for resholve_env_var in RESHOLVE_FAKE RESHOLVE_FIX RESHOLVE_KEEP RESHOLVE_PROLOGUE RESHOLVE_EPILOGUE; do
        real_var="''${!resholve_env_var}"
        if [[ -z "$real_var" ]]; then
          unset -v $resholve_env_var
        fi
      done
      pushd $out
      resholve --overwrite ${toString (flags ++ scripts)}
      popd
    '';
  }));
in
lib.extendDerivation true passthru self
