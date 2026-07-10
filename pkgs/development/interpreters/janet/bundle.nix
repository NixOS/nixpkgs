{
  stdenv,
  lib,
  janet,
  janetHooks,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      shimJPM ? false,

      nativeBuildInputs ? [ ],
      buildInputs ? [ ],

      ...
    }@attrs:
    {
      buildInputs = buildInputs ++ [ janet ];
      nativeBuildInputs =
        nativeBuildInputs
        ++ [
          janet
          janetHooks.bundleInstallHook
        ]
        ++ lib.optionals shimJPM [ janetHooks.bundleShimJpmHook ];

      meta = (attrs.meta or { }) // {
        broken = stdenv.hostPlatform != stdenv.buildPlatform;
      };
    };
}
