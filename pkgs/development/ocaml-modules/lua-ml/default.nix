{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
}:
buildDunePackage (finalAttrs: {
  pname = "lua-ml";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "lindig";
    repo = "lua-ml";
    tag = finalAttrs.version;
    hash = "sha256-+kg/hwcmRoM6sSL2GXOC2GrnJRu52BR5UiNu3nl5Lnk=";
  };

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "Embeddable Lua 2.5 interpreter implemented in OCaml";
    homepage = "https://github.com/lindig/lua-ml";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
