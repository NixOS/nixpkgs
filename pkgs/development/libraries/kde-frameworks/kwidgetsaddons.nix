{ kdeFramework, lib
, ecm
}:

kdeFramework {
  name = "kwidgetsaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
