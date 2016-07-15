{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, makeQtWrapper
, karchive, kconfigwidgets, ki18n, breeze-icons, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [ breeze-icons kconfigwidgets karchive ki18n kitemviews qtsvg ];
  postInstall = ''
    wrapQtProgram "$out/bin/kiconfinder5"
  '';
}
