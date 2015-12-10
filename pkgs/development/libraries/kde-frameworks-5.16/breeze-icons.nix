{ kdeFramework
, extra-cmake-modules
}:

kdeFramework {
  name = "breeze-icons";
  nativeBuildInputs = [ extra-cmake-modules ];
}
