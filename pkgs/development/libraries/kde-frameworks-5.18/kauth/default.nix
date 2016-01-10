{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, polkit-qt
}:

kdeFramework {
  name = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ polkit-qt ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [ ./kauth-policy-install.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
