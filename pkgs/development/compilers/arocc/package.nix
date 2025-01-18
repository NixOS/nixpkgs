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

  passthru = {
    inherit zig;
    isArocc = true;
    wrapped = wrapCCWith { cc = finalAttrs.finalPackage; };
    stdenv = overrideCC stdenv finalAttrs.passthru.wrapped;
  };

  meta = with lib; {
    description = "C compiler written in Zig.";
    homepage = "http://aro.vexu.eu/";
    license = with licenses; [
      mit
      unicode-30
    ];
    maintainers = with maintainers; [ RossComputerGuy ];
    mainProgram = "arocc";
  };
})
