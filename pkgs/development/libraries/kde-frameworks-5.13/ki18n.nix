{ kdeFramework, lib
, extra-cmake-modules
, gettext
, python
, qtscript
}:

kdeFramework {
  name = "ki18n";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtscript ];
  propagatedNativeBuildInputs = [ gettext python ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
