{ stdenv
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
, pytest
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f54dedcf6fea90a3e75c30cb65e0ab1e832760121f393b8d68edd711dbaf7187";
  };

  checkInputs = [
    dateutil
    pygments
    repeated_test
    unittest2
    pytest
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
  ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
  };

}
