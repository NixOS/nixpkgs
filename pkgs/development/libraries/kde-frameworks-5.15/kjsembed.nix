{ kdeFramework, lib, extra-cmake-modules, kdoctools, ki18n, kjs
, makeKDEWrapper, qtsvg
}:

kdeFramework {
  name = "kjsembed";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
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
