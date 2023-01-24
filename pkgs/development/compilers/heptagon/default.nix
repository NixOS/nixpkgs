{ lib
, stdenv
, fetchFromGitLab
, makeWrapper
, ocamlPackages
}:

stdenv.mkDerivation rec {
  pname = "heptagon";
  version = "1.05.00";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "synchrone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b4O48MQT3Neh8a1Z5wRgS701w6XrwpsbSMprlqTT+CE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = with ocamlPackages; [
    ocaml
    findlib
    menhir
    menhirLib
    ocamlgraph
    camlp4
    ocamlbuild
    lablgtk
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
  };
}
