{ stdenv, fetchFromGitHub, ocaml, findlib, which, sedlex_2, easy-format, xmlm, base64 }:

stdenv.mkDerivation rec {
  version = "0.6.15";
  pname = "piqi";
  name = "ocaml${ocaml.version}-${pname}-${version}";
 
  src = fetchFromGitHub {
    owner = "alavrik";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v04hs85xv6d4ysqxyv1dik34dx49yab9shpi4x7iv19qlzl7csb";
  };

  buildInputs = [ ocaml findlib which ];
  propagatedBuildInputs = [ sedlex_2 xmlm easy-format base64 ];

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
    homepage = "http://piqi.org";
    description = "Universal schema language and a collection of tools built around it";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
