{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:
buildDunePackage rec {
  pname = "lua-ml";
  version = "0.9.4";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "lindig";
    repo = "lua-ml";
    tag = version;
    hash = "sha256-kMBTHzmlrRWNpWwG321jYcM61rE1J3YQkygSrfnZ6Wc=";
  };

  meta = {
    description = "Embeddable Lua 2.5 interpreter implemented in OCaml";
    inherit (src.meta) homepage;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
