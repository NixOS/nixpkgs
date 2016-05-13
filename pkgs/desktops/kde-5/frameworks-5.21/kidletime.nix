{ kdeFramework, lib
, extra-cmake-modules
, qtbase
, qtx11extras
}:

kdeFramework {
  name = "kidletime";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtbase qtx11extras ];
}
