{stdenv, fetchurl, ocaml, findlib, gdome2, libxslt, pkgconfig}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.2.6";
  pname = "gmetadom";

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0skmlv0pnqvg99wzzzi1h4zhwzd82xg7xpkj1kwpfy7bzinjh7ig";
  };

  patches = [ ./gcc-4.3.dpatch ];

  dontDisableStatic = true;

  preConfigure=''
    configureFlags="--with-ocaml-lib-prefix=$out/lib/ocaml/${ocaml_version}/site-lib"
  '';


  buildInputs = [ocaml findlib pkgconfig gdome2 libxslt];
  propagatedBuildInputs = [gdome2];

  meta = {
    homepage = http://gmetadom.sourceforge.net/;
    description = "GMetaDOM is a collection of librares, each library providing a DOM implementation";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
