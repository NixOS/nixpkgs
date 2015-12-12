{ kdeFramework, lib
, extra-cmake-modules
, gettext
, python
, qtdeclarative
, qtscript
}:

kdeFramework {
  name = "ki18n";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtdeclarative qtscript ];
  propagatedNativeBuildInputs = [ gettext python ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
