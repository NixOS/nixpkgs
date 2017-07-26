{ stdenv, makeWrapper, buildOcaml, fetchFromGitHub,
  ocaml, opam, topkg, menhir, merlin_extend, ppx_tools_versioned, utop }:

let 
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "reason";
    rev = version;
    sha256 = "0l3lwfvppplah707rq5nqjav2354lq6d7xfflfigkzhn74hlx6iy";
  };
  meta = with stdenv.lib; {
    homepage = https://facebook.github.io/reason/;
    description = "Facebook's friendly syntax to OCaml";
    license = licenses.bsd3;
    maintainers = [ maintainers.volth ];
  };

  reason-parser = buildOcaml {
    name = "reason-parser";
    inherit version src meta;
    sourceRoot = "reason-${version}-src/reason-parser";

    minimumSupportedOcamlVersion = "4.02";

    propagatedBuildInputs = [ menhir merlin_extend ppx_tools_versioned ];
    buildInputs = [ opam topkg ];

    createFindlibDestdir = true;

    inherit (topkg) installPhase;
  };
in
buildOcaml {
  name = "reason";
  inherit version src meta;

  buildInputs = [ makeWrapper opam topkg reason-parser utop ];

  buildFlags = [ "build" ]; # do not "make tests" before reason lib is installed

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace src/reasonbuild.ml --replace "refmt --print binary" "$out/bin/refmt --print binary"
  '';

  installPhase = ''
    ${topkg.installPhase}

    wrapProgram $out/bin/reup \
      --prefix PATH : "${opam}/bin"
    wrapProgram $out/bin/rtop \
      --prefix PATH : "${utop}/bin" \
      --set OCAMLPATH $out/lib/ocaml/${ocaml.version}/site-lib:$OCAMLPATH
  '';
}
