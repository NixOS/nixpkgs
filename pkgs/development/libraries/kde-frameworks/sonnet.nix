{ kdeFramework, lib
, ecm
, hunspell
}:

kdeFramework {
  name = "sonnet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  buildInputs = [ hunspell ];
}
