{ kdeFramework, lib
, extra-cmake-modules
, python
}:

kdeFramework {
  name = "kapidox";
  nativeBuildInputs = [ extra-cmake-modules python ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
