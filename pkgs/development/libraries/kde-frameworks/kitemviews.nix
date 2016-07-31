{ kdeFramework, lib
, ecm
}:

kdeFramework {
  name = "kitemviews";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
