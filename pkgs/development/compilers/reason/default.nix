{ stdenv, makeWrapper, buildOcaml, fetchFromGitHub,
  ocaml, opam, topkg, menhir, merlin_extend, ppx_tools_versioned, utop }:

buildOcaml rec {
  name = "reason";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = version;
    sha256 = "0vj3y9vlm9gqvj9grmb9n487avbrj4q5611m7wv1bsdpndvv96jr";
  };

  propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];

  buildInputs = [ makeWrapper opam topkg utop menhir opam topkg ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace src/reasonbuild.ml --replace "refmt --print binary" "$out/bin/refmt --print binary"
  '';

  installPhase = ''
    ${topkg.installPhase}

    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --set OCAMLPATH $out/lib/ocaml/${ocaml.version}/site-lib:$OCAMLPATH
  '';

  meta = with stdenv.lib; {
    homepage = https://facebook.github.io/reason/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.bsd3;
    maintainers = [ maintainers.volth ];
  };
}
