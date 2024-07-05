{ lib
, stdenv
, fetchFromGitLab
, makeWrapper
, ocamlPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "heptagon";
  version = "1.05.00";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "synchrone";
    repo = "heptagon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b4O48MQT3Neh8a1Z5wRgS701w6XrwpsbSMprlqTT+CE=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    camlp4
    findlib
    makeWrapper
    menhir
    ocaml
    ocamlbuild
  ];

  buildInputs = with ocamlPackages; [
    camlp4
    lablgtk
    menhirLib
    ocamlgraph
  ];

  # the heptagon library in lib/heptagon is not executable
  postInstall = ''
    find $out/lib/heptagon -type f -exec chmod -x {} \;
  '';

  postFixup = with ocamlPackages; ''
    wrapProgram $out/bin/hepts \
      --prefix CAML_LD_LIBRARY_PATH : "${lablgtk}/lib/ocaml/${ocaml.version}/site-lib/lablgtk2"
  '';

  meta = with lib; {
    description = "Compiler for the Heptagon/BZR synchronous programming language";
    homepage = "https://gitlab.inria.fr/synchrone/heptagon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    mainProgram = "heptc";
    platforms = platforms.unix;
  };
})
