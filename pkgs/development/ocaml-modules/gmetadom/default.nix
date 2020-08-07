{stdenv, fetchurl, ocaml, findlib, gdome2, libxslt, pkgconfig}:

let
  pname = "gmetadom";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0skmlv0pnqvg99wzzzi1h4zhwzd82xg7xpkj1kwpfy7bzinjh7ig";
  };

  patches = [ ./gcc-4.3.patch ];

  dontDisableStatic = true;

  preConfigure=''
    configureFlags="--with-ocaml-lib-prefix=$out/lib/ocaml/${ocaml.version}/site-lib"
  '';


  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ocaml findlib gdome2 libxslt];
  propagatedBuildInputs = [gdome2];

  meta = {
    homepage = "http://gmetadom.sourceforge.net/";
    description = "A collection of librares, each library providing a DOM implementation";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
