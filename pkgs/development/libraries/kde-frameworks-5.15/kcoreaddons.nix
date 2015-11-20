{ kdeFramework, lib
, extra-cmake-modules
, shared_mime_info
}:

kdeFramework {
  name = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ shared_mime_info ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
