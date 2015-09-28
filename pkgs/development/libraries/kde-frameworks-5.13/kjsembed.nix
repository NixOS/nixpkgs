{ mkDerivation, lib
, extra-cmake-modules
, kdoctools
, ki18n
, kjs
, qtsvg
}:

mkDerivation {
  name = "kjsembed";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ qtsvg ];
  propagatedBuildInputs = [ ki18n kjs ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kjscmd5"
    wrapKDEProgram "$out/bin/kjsconsole"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
