{ kdeFramework, lib
, extra-cmake-modules
, python
}:

kdeFramework {
  name = "kapidox";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules python ];
}
