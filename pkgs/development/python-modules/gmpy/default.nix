{ buildPythonPackage, fetchurl, isPyPy, gmp } :

let
  pname = "gmpy";
  version = "1.17";
in

buildPythonPackage {
  inherit pname version;

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://pypi/g/gmpy/${pname}-${version}.zip";
    sha256 = "1a79118a5332b40aba6aa24b051ead3a31b9b3b9642288934da754515da8fa14";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "GMP or MPIR interface to Python 2.4+ and 3.x";
    homepage = http://code.google.com/p/gmpy/;
  };
}
