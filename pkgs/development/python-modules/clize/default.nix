{ lib
, buildPythonPackage
, fetchPypi
, dateutil
, sigtools
, six
, attrs
, od
, docutils
, repeated_test
, pygments
, unittest2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f54dedcf6fea90a3e75c30cb65e0ab1e832760121f393b8d68edd711dbaf7187";
  };

  # Remove overly restrictive version constraints
  postPatch = ''
    substituteInPlace setup.py --replace "attrs>=19.1.0,<20" "attrs"
  '';

  checkInputs = [
    pytestCheckHook
    dateutil
    pygments
    repeated_test
    unittest2
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
  ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
  };
}
