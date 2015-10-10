{ kdeFramework, lib, extra-cmake-modules, karchive, kconfig
, kguiaddons, ki18n, kio, kiconthemes, kparts, perl, qtscript
, qtxmlpatterns, sonnet
}:

kdeFramework {
  name = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons kiconthemes kio kparts qtscript
    qtxmlpatterns sonnet
  ];
  propagatedBuildInputs = [ ki18n ];
  patches = [ ./0001-no-qcoreapplication.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
