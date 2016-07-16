{ kdeFramework, lib
, extra-cmake-modules
, shared_mime_info
}:

kdeFramework {
  name = "kcoreaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ shared_mime_info ];
}
