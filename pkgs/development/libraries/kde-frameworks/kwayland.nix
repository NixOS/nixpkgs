{ kdeFramework
, ecm
, wayland
}:

kdeFramework {
  name = "kwayland";
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    wayland
  ];
}
