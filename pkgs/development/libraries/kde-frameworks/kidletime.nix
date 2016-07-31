{ kdeFramework, lib
, ecm
, qtbase
, qtx11extras
}:

kdeFramework {
  name = "kidletime";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtbase qtx11extras ];
}
