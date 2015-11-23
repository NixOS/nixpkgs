{ kdeFramework
, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "oxygen-icons5";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
