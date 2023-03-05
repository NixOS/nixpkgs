{stdenv, lib, fetchurl, ocaml, findlib, gdome2, libxslt, pkg-config}:

let
  pname = "gmetadom";
in

lib.throwIf (lib.versionAtLeast ocaml.version "4.14")
  "${pname} is not available for OCaml ${ocaml.version}"

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

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  buildInputs = [ libxslt ];
  propagatedBuildInputs = [ gdome2 ];

  strictDeps = true;

  meta = {
    homepage = "https://gmetadom.sourceforge.net/";
    description = "A collection of librares, each library providing a DOM implementation";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.roconnor ];
  };
}
