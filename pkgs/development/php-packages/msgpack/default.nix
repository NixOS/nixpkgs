{ buildPecl, lib }:

buildPecl {
  pname = "msgpack";

  version = "2.1.2";
  sha256 = "10my5a0547x15jfc6r9a84afd7604fpgb7an0k5sfgij7z9z8bwi";

  meta.maintainers = lib.teams.php.members;
}
