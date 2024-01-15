{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  version = "1.1.0";
  format = "setuptools";
  pname = "pytest-random-order";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+beu5NTp6+YTMnt2+s1d91Nu8wVKaeePSH2jtm0VgU=";
  };

  disabled = pythonOlder "3.5";

  buildInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://github.com/jbasko/pytest-random-order";
    description = "Randomise the order of tests with some control over the randomness";
    license = licenses.mit;
    maintainers = [ maintainers.prusnak ];
  };
}
