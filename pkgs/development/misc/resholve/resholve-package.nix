{ stdenv, lib, resholve }:

{ pname
, src
, version
, passthru ? { }
  # resholve-specific API
, solutions
  /* not sure how to document the structure now :[
    {
      shortname = {
        # required
        # paths to try resolving
        scripts = [ $out-relative paths ];
        # packages to resolve executables from
        inputs = [ packages ];
        interpreter = "${bash}/bin/bash";

        # optional
        # see 'man resholve', but fake/fix/keep are mostly
        # key: [list] mapped to key:value2;value2
        fake = { fake directives };
        fix = { fix directives };
        keep = { keep directives };
        # file to inject before first code-line of script
        prologue = file;
        # file to inject after last code-line of script
        epilogue = file;
        # extra command-line flags passed to resholve; generally the API here
        # should align with what resholve supports, but flags is helpful if you
        # need to override the version of resholve in use.
        flags = [ ];
      };
    }*/
, ...
}@attrs:
let
  inherit stdenv;
  /*
   * function doc TODO if this doesn't get slapped down
   */
  nope =
    path:
    msg:
    throw "${lib.concatStringsSep "." path}: ${msg}";
  spaces = l: builtins.concatStringsSep " " l;
  makeDirective = sol: env: n: v:
    if builtins.isInt v then builtins.toString v
    else if builtins.isString v then n
    else if true == v then n
    else if false == v then "" # omit!
    else if null == v then "" # omit!
    else if builtins.isList v then "${n}:${builtins.concatStringsSep ";" v}"
    else nope [ sol env n ] "unexpected type '${builtins.typeOf v}'";
  makeDirectives =
    solution:
    env:
    v:
    lib.mapAttrsToList (makeDirective solution env) v;
  makeEnvVal = solution: env: v:
    if env == "inputs" then lib.makeBinPath v
    else if builtins.isString v then v
    else if builtins.isList v then spaces v
    else if builtins.isAttrs v then spaces (makeDirectives solution env v)
    else nope [ solution env ] "type of '${v}' (${builtins.typeOf v})";
  shellEnv =
    solution:
    env:
    value:
    lib.escapeShellArg (makeEnvVal solution env value);
  makeEnv = solution: env: value:
    "RESHOLVE_${lib.toUpper env}=${shellEnv solution env value}";
  scrub =
    value:
    removeAttrs value [ "scripts" "flags" ];
  validateSolution = { scripts, inputs, interpreter, ... }: true;
  makeEnvs =
    solution:
    value:
    lib.concatStringsSep " " (lib.mapAttrsToList (makeEnv solution) (scrub value));
  makeArgs =
    { flags ? [ ], scripts, ... }:
    lib.concatStringsSep " " (flags ++ scripts);
  makeInvocation =
    solution:
    value:
    if validateSolution value then
      "${makeEnvs solution value} resholve --overwrite ${makeArgs value}"
    else throw "invalid solution"; # shouldn't trigger for now
  makeCommands =
    solutions:
    lib.mapAttrsToList makeInvocation solutions;

  self = (stdenv.mkDerivation ((removeAttrs attrs [ "solutions" ])
    // {
    inherit pname version src;
    buildInputs = [ resholve ];

    #LOGLEVEL="INFO";
    preFixup = ''
      pushd $out
      ${lib.concatStringsSep "\n" (makeCommands solutions)}
      popd
    '';
  }));
in
lib.extendDerivation true passthru self
