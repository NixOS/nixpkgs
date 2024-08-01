{
  lib,
  stdenv,
  wrapCCWith,
  overrideCC,
  zig,
  version,
  src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arocc";
  inherit version src;

  nativeBuildInputs = [ zig.hook ];

  outputs = [
    "out"
    "lib"
  ];

  passthru = {
    inherit zig;
    isArocc = true;
    wrapped = wrapCCWith {
      cc = finalAttrs.finalPackage;
      inherit (finalAttrs.passthru.zig.passthru.stdenv.cc) bintools;
    };
    stdenv = overrideCC stdenv finalAttrs.passthru.wrapped;
  };

  postInstall = ''
    # Fake for eval
    mkdir -p $lib
  '';

  meta = {
    description = "C compiler written in Zig.";
    homepage = "http://aro.vexu.eu/";
    license = with lib.licenses; [
      mit
      unicode-30
    ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    mainProgram = "arocc";
  };
})
