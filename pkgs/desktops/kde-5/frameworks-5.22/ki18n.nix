{ kdeFramework, lib
, extra-cmake-modules
, gettext
, python
, qtdeclarative
, qtscript
}:

kdeFramework {
  name = "ki18n";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtdeclarative qtscript ];
  propagatedNativeBuildInputs = [ gettext python ];
}
