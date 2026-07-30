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
  version = "1.0.11";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "mbacarella";
    repo = "curses";
    rev = finalAttrs.version;
    hash = "sha256-tjBOv7RARDzBShToNLL9LEaU/Syo95MfwZunFsyN4/Q=";
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
