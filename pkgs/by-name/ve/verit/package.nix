{
  lib,
  gccStdenv,
  fetchurl,
  gmp,
  flex,
  bison,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "veriT";
  version = "2026.05";

  src = fetchurl {
    url = "https://www.verit-solver.org/download/${finalAttrs.version}/verit-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-wNN1S1mdAsBENZBkDs770t31YDt63Nj737MbhOWcwvE=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];
  buildInputs = [ gmp ];

  # --disable-static actually enables static linking here...
  dontDisableStatic = true;

  makeFlags = [ "LEX=${flex}/bin/flex" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Open, trustable and efficient SMT-solver";
    homepage = "https://www.verit-solver.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      jvanbruegge
      sempiternal-aurora
    ];
  };
})
