{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ncurses,
  dune-configurator,
  pkg-config,
}:

buildDunePackage (finalAttrs: {
  pname = "curses";
  version = "1.0.12";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "mbacarella";
    repo = "curses";
    rev = finalAttrs.version;
    hash = "sha256-g7YveFRuS+uTq8Ps8+cU93CRFOXW+fjJfs4rafTVmIg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ ncurses ];

  meta = {
    description = "OCaml Bindings to curses/ncurses";
    homepage = "https://github.com/mbacarella/curses";
    license = lib.licenses.lgpl21Plus;
    changelog = "https://github.com/mbacarella/curses/raw/${finalAttrs.version}/CHANGES";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
