{ kdeFramework, lib
, extra-cmake-modules
, karchive
, kconfig
, kcoreaddons
, kservice
}:

kdeFramework {
  name = "kemoticons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kconfig kcoreaddons ];
  propagatedBuildInputs = [ kservice ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
