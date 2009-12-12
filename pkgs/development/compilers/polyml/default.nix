{stdenv, fetchurl}:

let
  pname = "polyml";
  version = "5.3";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}.${version}.tar.gz";
    sha256 = "154e836f4e65b5c72f8190d3c02e5ed237921cef716cb49add1e0e1e35fb2af4";
  };

  meta = {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = http://www.polyml.org/;
    license = "LGPL";
  };
}
