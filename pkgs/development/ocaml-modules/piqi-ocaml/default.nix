{stdenv, fetchurl, ocaml, findlib, piqi, ulex, easy-format, xmlm, base64, camlp4}:

stdenv.mkDerivation rec {
  version = "0.7.4";
  name    = "piqi-ocaml-${version}";

  src = fetchurl {
    url = "https://github.com/alavrik/piqi-ocaml/archive/v${version}.tar.gz";
    sha256 = "064c74f031l847q6s1vilj77n7h7i84jn8c83yid9nha3dssaf7m";
  };

  buildInputs = [ocaml findlib piqi base64 camlp4];

  createFindlibDestdir = true;

  installPhase = "DESTDIR=$out make install";

  meta = with stdenv.lib; {
    homepage = http://piqi.org;
    description = "Universal schema language and a collection of tools built around it. These are the ocaml bindings";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
