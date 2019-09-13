{ stdenv, fetchurl, ocaml, findlib, which, ulex, easy-format, ocaml_optcomp, xmlm, base64 }:

stdenv.mkDerivation rec {
  version = "0.6.14";
  pname = "piqi";
 
  src = fetchurl {
    url = "https://github.com/alavrik/piqi/archive/v${version}.tar.gz";
    sha256 = "1ssccnwqzfyf7syfq2fv4zyhwayxwd75rhq9y28mvq1w6qbww4l7";
  };

  buildInputs = [ ocaml findlib which ocaml_optcomp ];
  propagatedBuildInputs = [ulex xmlm easy-format base64];

  patches = [ ./no-ocamlpath-override.patch ];

  createFindlibDestdir = true;

  buildPhase = ''
    make
    make -C piqilib piqilib.cma
  '';

  installPhase = ''
    make install;
    make ocaml-install;
  '';

  meta = with stdenv.lib; {
    homepage = http://piqi.org;
    description = "Universal schema language and a collection of tools built around it";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
