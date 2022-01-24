{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  version = "1.0.4";
  pname = "pytest-random-order";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b2159342a4c8c10855bc4fc6d65ee890fc614cb2b4ff688979b008a82a0ff52";
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
