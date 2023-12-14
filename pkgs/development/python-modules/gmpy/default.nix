{ buildPythonPackage, fetchurl, isPyPy, gmp, pythonAtLeast } :

let
  pname = "gmpy";
  version = "1.17";
  format = "setuptools";
in

buildPythonPackage {
  inherit pname version;

  # Python 3.11 has finally made changes to its C API for which gmpy 1.17,
  # published in 2013, would require patching. It seems unlikely that any
  # patches will be forthcoming.
  disabled = isPyPy || pythonAtLeast "3.11";

  src = fetchurl {
    url = "mirror://pypi/g/gmpy/${pname}-${version}.zip";
    sha256 = "1a79118a5332b40aba6aa24b051ead3a31b9b3b9642288934da754515da8fa14";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "GMP or MPIR interface to Python 2.4+ and 3.x";
    homepage = "https://github.com/aleaxit/gmpy/";
  };
}
