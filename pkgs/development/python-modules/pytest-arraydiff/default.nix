{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-arraydiff";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "714149beffd0dfa085477c65791c1139b619602b049536353ce1a91397fb3bd2";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    numpy
    six
  ];

  # The tests requires astropy, which itself requires
  # pytest-arraydiff. This causes an infinite recursion if the tests
  # are enabled.
  doCheck = false;

  meta = with lib; {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = "https://github.com/astrofrog/pytest-arraydiff";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
