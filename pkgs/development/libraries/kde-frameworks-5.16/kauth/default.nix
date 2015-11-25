{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, polkitQt
}:

kdeFramework {
  name = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ polkitQt ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [ ./kauth-policy-install.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
