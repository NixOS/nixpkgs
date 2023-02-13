{ lib, stdenv, fetchFromGitHub
, ocaml, findlib, pkg-config
, gmp
}:

if lib.versionOlder ocaml.version "4.04"
then throw "zarith is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-zarith";
  version = "1.12";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "Zarith";
    rev = "release-${version}";
    sha256 = "1jslm1rv1j0ya818yh23wf3bb6hz7qqj9pn5fwl45y9mqyqa01s9";
  };

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  propagatedBuildInputs = [ gmp ];
  strictDeps = true;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];
  configureFlags = [ "-installdir ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib" ];

  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = with lib; {
    description = "Fast, arbitrary precision OCaml integers";
    homepage    = "http://forge.ocamlcore.org/projects/zarith";
    license     = licenses.lgpl2;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
