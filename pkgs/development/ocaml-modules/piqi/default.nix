{stdenv, fetchurl, ocaml, findlib, camlp4, which, ulex, easy-format, ocaml_optcomp, xmlm, base64}:

stdenv.mkDerivation rec {
  version = "0.6.12";
  name    = "piqi-${version}";
 
  src = fetchurl {
    url = "https://github.com/alavrik/piqi/archive/v${version}.tar.gz";
    sha256 = "1ifnawnblvibf5rgp6gr4f20266dckfrlryikg1iiq3dx2wfl7f8";
  };

  buildInputs = [ocaml findlib camlp4 which ocaml_optcomp base64];
  propagatedBuildInputs = [ulex xmlm easy-format];

  patches = [ ./no-ocamlpath-override.patch ];

  createFindlibDestdir = true;

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
