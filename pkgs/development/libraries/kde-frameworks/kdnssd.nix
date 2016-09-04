{ kdeFramework, lib
, ecm
, avahi
}:

kdeFramework {
  name = "kdnssd";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ avahi ];
}
