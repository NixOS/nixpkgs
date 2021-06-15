{ stdenv, lib, resholve }:

{ pname
, src
, version
, passthru ? { }
, solutions
, ...
}@attrs:
let
  inherit stdenv;
  /* These functions break up the work of partially validating the
   * 'solutions' attrset and massaging it into env/cli args.
   *
   * Note: some of the left-most args do not *have* to be passed as
   * deep as they are, but I've done so to provide more error context
   */

  # for brevity / line length
  spaces = l: builtins.concatStringsSep " " l;
  semicolons = l: builtins.concatStringsSep ";" l;

  /* Throw a fit with dotted attr path context */
  nope = path: msg:
    throw "${builtins.concatStringsSep "." path}: ${msg}";

  /* Special-case directive value representations by type */
  makeDirective = solution: env: name: val:
    if builtins.isInt val then builtins.toString val
    else if builtins.isString val then name
    else if true == val then name
    else if false == val then "" # omit!
    else if null == val then "" # omit!
    else if builtins.isList val then "${name}:${semicolons val}"
    else nope [ solution env name ] "unexpected type: ${builtins.typeOf val}";

  /* Build fake/fix/keep directives from Nix types */
  makeDirectives = solution: env: val:
    lib.mapAttrsToList (makeDirective solution env) val;

  /* Special-case value representation by type/name */
  makeEnvVal = solution: env: val:
    if env == "inputs" then lib.makeBinPath val
    else if builtins.isString val then val
    else if builtins.isList val then spaces val
    else if builtins.isAttrs val then spaces (makeDirectives solution env val)
    else nope [ solution env ] "unexpected type: ${builtins.typeOf val}";

  /* Shell-format each env value */
  shellEnv = solution: env: value:
    lib.escapeShellArg (makeEnvVal solution env value);

  /* Build a single ENV=val pair */
  makeEnv = solution: env: value:
    "RESHOLVE_${lib.toUpper env}=${shellEnv solution env value}";

  /* Discard attrs claimed by makeArgs */
  removeCliArgs = value:
    removeAttrs value [ "scripts" "flags" ];

  /* Verify required arguments are present */
  validateSolution = { scripts, inputs, interpreter, ... }: true;

  /* Pull out specific solution keys to build ENV=val pairs */
  makeEnvs = solution: value:
    spaces (lib.mapAttrsToList (makeEnv solution) (removeCliArgs value));

  /* Pull out specific solution keys to build CLI argstring */
  makeArgs = { flags ? [ ], scripts, ... }:
    spaces (flags ++ scripts);

  /* Build a single resholve invocation */
  makeInvocation = solution: value:
    if validateSolution value then
      "${makeEnvs solution value} resholve --overwrite ${makeArgs value}"
    else throw "invalid solution"; # shouldn't trigger for now

  /* Build resholve invocation for each solution. */
  makeCommands = solutions:
    lib.mapAttrsToList makeInvocation solutions;

  self = (stdenv.mkDerivation ((removeAttrs attrs [ "solutions" ])
    // {
    inherit pname version src;
    buildInputs = [ resholve ];

    # enable below for verbose debug info if needed
    # supports default python.logging levels
    # LOGLEVEL="INFO";
    preFixup = ''
      pushd "$out"
      ${builtins.concatStringsSep "\n" (makeCommands solutions)}
      popd
    '';
  }));
in
lib.extendDerivation true passthru self
