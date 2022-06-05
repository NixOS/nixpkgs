{ lib, buildPythonPackage, fetchPypi
, defcon, fontmath
, unicodedata2, fs
}:

buildPythonPackage rec {
  pname = "MutatorMath";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r1qq45np49x14zz1zwkaayqrn7m8dn2jlipjldg2ihnmpzw29w1";
    extension = "zip";
  };

  propagatedBuildInputs = [ fontmath unicodedata2 defcon ];
  checkInputs = [ unicodedata2 fs ];

  meta = with lib; {
    description = "Piecewise linear interpolation in multiple dimensions with multiple, arbitrarily placed, masters";
    homepage = "https://github.com/LettError/MutatorMath";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
