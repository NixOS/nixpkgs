{ buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
, lib
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xw1gg2c6zpw9s7i7q34qf0qxqdfj8nc2k1xnzqpw5q315db071l";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkPhase = ''
    python -m aioitertools.tests
  '';

  meta = with lib; {
    homepage = "https://github.com/omnilib/aioitertools";
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables.";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
