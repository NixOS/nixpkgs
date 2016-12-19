{ kdeFramework, lib
, ecm
, gettext
, python
, qtdeclarative
, qtscript
}:

kdeFramework {
  name = "ki18n";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtdeclarative qtscript ];
  propagatedNativeBuildInputs = [ gettext python ];
}
