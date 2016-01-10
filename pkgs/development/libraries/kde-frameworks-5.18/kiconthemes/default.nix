{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, makeQtWrapper
, kconfigwidgets, ki18n, breeze-icons, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [ kconfigwidgets kitemviews qtsvg ];
  propagatedBuildInputs = [ breeze-icons ki18n ];
  postInstall = ''
    wrapQtProgram "$out/bin/kiconfinder5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
