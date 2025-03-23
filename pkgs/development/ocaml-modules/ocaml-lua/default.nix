{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  lua5_1,
  pkg-config,
}:

buildDunePackage {
  pname = "ocaml-lua";
  version = "1.8";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "pdonadeo";
    repo = "ocaml-lua";
    # Take the latest commit, as some warnings have been fixed/suppressed
    rev = "f44ad50c88bf999f48a13af663051493c89d7d02";
    hash = "sha256-AXtKrty8JdI+yc+Y9EiufBbySlr49OyXW6wKwmDb0xo=";
  };

  # ocaml-lua vendors and builds Lua: replace that with the one from nixpkgs
  postPatch = ''
    rm -r src/lua_c
    substituteInPlace src/dune \
      --replace "-Ilua_c/lua515/src" "" \
      --replace "(libraries unix threads lua_c)" \
                "(libraries unix threads) (c_library_flags -llua)"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lua5_1 ];

  doCheck = true;

  meta = {
    description = "Lua bindings for OCaml";
    homepage = "https://pdonadeo.github.io/ocaml-lua";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kenran ];
  };
}
