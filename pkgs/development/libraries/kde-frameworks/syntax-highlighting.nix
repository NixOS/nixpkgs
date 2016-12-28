{ kdeFramework, lib
, ecm, perl
}:

kdeFramework {
  name = "syntax-highlighting";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm perl ];
}
