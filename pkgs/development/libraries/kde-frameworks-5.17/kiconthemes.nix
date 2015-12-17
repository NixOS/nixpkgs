{ kdeFramework, lib, makeQtWrapper
, extra-cmake-modules, kconfigwidgets, ki18n
, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [ kconfigwidgets kitemviews qtsvg ];
  propagatedBuildInputs = [ ki18n ];
  postInstall = ''
    wrapQtProgram "$out/bin/kiconfinder5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
