{ stdenv, fetchFromGitHub, ocaml, findlib, camlp5
, ppx_tools_versioned, ppx_deriving, re
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "elpi is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-elpi-${version}";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "LPCIC";
    repo = "elpi";
    rev = "v${version}";
    sha256 = "1n4jpidx0vk4y66bhd704ajn8n6f1fd5wsi1shj6wijfmjl14h7s";
  };

  buildInputs = [ ocaml findlib ppx_tools_versioned ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  createFindlibDestdir = true;

  preInstall = "make byte";

  postInstall = ''
    mkdir -p $out/bin
    make install-bin BIN=$out/bin
    make install-bin BYTE=1 BIN=$out/bin
  '';

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
