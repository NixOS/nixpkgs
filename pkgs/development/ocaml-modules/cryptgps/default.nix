{stdenv, fetchurl, ocaml, findlib}:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "cryptgps is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml-cryptgps-${version}";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.camlcity.org/download/cryptgps-0.2.1.tar.gz";
    sha256 = "1mp7i42cm9w9grmcsa69m3h1ycpn6a48p43y4xj8rsc12x9nav3s";
  };

  buildInputs = [ocaml findlib];

  dontConfigure = true;	# Skip configure phase

  createFindlibDestdir = true;

  meta = {
    homepage = http://projects.camlcity.org/projects/cryptgps.html;
    description = "Cryptographic functions for OCaml";
    longDescription = ''
      This library implements the symmetric cryptographic algorithms
      Blowfish, DES, and 3DES. The algorithms are written in O'Caml,
      i.e. this is not a binding to some C library, but the implementation
      itself.
    '';
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
