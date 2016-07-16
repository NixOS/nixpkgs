{ kdeFramework
, extra-cmake-modules
, qtsvg
}:

kdeFramework {
  name = "breeze-icons";
  outputs = [ "out" ];
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtsvg ];
}
