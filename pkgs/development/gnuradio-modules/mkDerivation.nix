{
  lib,
  unwrapped,
}:

mkDerivation:

args:

let
  # Common validation and processing logic
  processArgs =
    args:
    # Check if it's supposed to not get built for the current gnuradio version
    if (builtins.hasAttr "disabled" args) && args.disabled then
      let
        name = args.name or "${args.pname}";
      in
      throw "Package ${name} is incompatible with GNURadio ${unwrapped.versionAttr.major}"
    else

    if builtins.hasAttr "disabledForGRafter" args then
      throw ''
        `disabledForGRafter` is superseded by `disabled`.
        Use `disabled = gnuradioAtLeast "${args.disabledForGRafter}";` instead.
      ''
    else

      let
        args_ = {
          enableParallelBuilding = args.enableParallelBuilding or true;
          nativeBuildInputs = (args.nativeBuildInputs or [ ]);
          # We add gnuradio and volk itself by default - most gnuradio based packages
          # will not consider it a dependency worth mentioning and it will almost
          # always be needed
          buildInputs = (args.buildInputs or [ ]) ++ [
            unwrapped
            unwrapped.volk
          ];
        };
      in
      args // args_;

in
if builtins.isFunction args then
  # Function form: args is (finalAttrs -> attrset)
  mkDerivation (finalAttrs: processArgs (args finalAttrs))
else
  # Attrset form: args is attrset
  mkDerivation (processArgs args)
