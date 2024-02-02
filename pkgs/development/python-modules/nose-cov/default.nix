{ buildPythonPackage, fetchPypi, lib, nose, cov-core }:

buildPythonPackage rec {
  pname = "nose-cov";
  version = "1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04j4fw01bv648gimqqj4z88606lcczbm1k326agcc74gb4sh7v4b";
  };

  propagatedBuildInputs = [ nose cov-core ];

  meta = with lib; {
    homepage = "https://pypi.org/project/nose-cov/";
    license = licenses.mit;
    description = "This plugin produces coverage reports. It also supports coverage of subprocesses.";
    maintainers = with maintainers; [ ];
  };
}
