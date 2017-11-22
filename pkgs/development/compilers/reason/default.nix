{ stdenv, makeWrapper, buildOcaml, fetchFromGitHub,
  ocaml, opam, jbuilder, menhir, merlin_extend, ppx_tools_versioned, utop }:

buildOcaml rec {
  name = "reason";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = "v${version}";
    sha256 = "1rpaazy0m76qidxwdr51qrgs3ryyz875rndwp9p30siqd04raswq";
  };

  propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];

  buildInputs = [ makeWrapper opam jbuilder utop menhir ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace src/reasonbuild/myocamlbuild.ml \
      --replace "refmt --print binary" "$out/bin/refmt --print binary"
  '';

  installPhase = ''
    ${jbuilder.installPhase}

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
