{ kdeFramework, lib
, extra-cmake-modules
, qtbase
, qtx11extras
}:

kdeFramework {
  name = "kidletime";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
