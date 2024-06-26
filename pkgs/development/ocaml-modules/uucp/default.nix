{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  uchar,
  uutf,
  uunf,
  uucd,
}:

let
  pname = "uucp";
  version = "15.1.0";
  webpage = "https://erratique.ch/software/${pname}";
  minimalOCamlVersion = "4.03";
  doCheck = true;
in

if lib.versionOlder ocaml.version minimalOCamlVersion then
  builtins.throw "${pname} needs at least OCaml ${minimalOCamlVersion}"
else

  stdenv.mkDerivation {

    name = "ocaml${ocaml.version}-${pname}-${version}";

    src = fetchurl {
      url = "${webpage}/releases/${pname}-${version}.tbz";
      hash = "sha256-qR5LiAZHt4oD3ak0x17GqbYXNaJmJxFk/WGoxT+yWYc=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
      topkg
    ];
    buildInputs = [
      topkg
      uutf
      uunf
      uucd
    ];

    propagatedBuildInputs = [ uchar ];

    strictDeps = true;

    buildPhase = ''
      runHook preBuild
      ${topkg.buildPhase} --with-cmdliner false --tests ${lib.boolToString doCheck}
      runHook postBuild
    '';

    inherit (topkg) installPhase;

    inherit doCheck;
    checkPhase = ''
      runHook preCheck
      ${topkg.run} test
      runHook postCheck
    '';
    checkInputs = [ uucd ];

    meta = with lib; {
      description = "OCaml library providing efficient access to a selection of character properties of the Unicode character database";
      homepage = webpage;
      inherit (ocaml.meta) platforms;
      license = licenses.bsd3;
      maintainers = [ maintainers.vbgl ];
    };
  }
