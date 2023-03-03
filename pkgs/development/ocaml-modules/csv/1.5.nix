{ lib, stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-csv";
  version = "1.5";

  src = fetchzip {
    url = "https://github.com/Chris00/ocaml-csv/releases/download/${version}/csv-${version}.tar.gz";
    sha256 = "1ca7jgg58j24pccs5fshis726s06fdcjshnwza5kwxpjgdbvc63g";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

  strictDeps = true;

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";

  buildPhase = "ocaml setup.ml -build";

  doCheck = true;
  checkPhase = "ocaml setup.ml -test";

  installPhase = ''
    runHook preInstall
    ocaml setup.ml -install
    runHook postInstall
  '';

  meta = with lib; {
    description = "A pure OCaml library to read and write CSV files";
    homepage = "https://github.com/Chris00/ocaml-csv";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
