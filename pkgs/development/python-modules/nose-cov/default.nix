{ buildPythonPackage, fetchPypi, lib, nose, covCore }:

buildPythonPackage rec {
  pname = "nose-cov";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04j4fw01bv648gimqqj4z88606lcczbm1k326agcc74gb4sh7v4b";
  };

  propagatedBuildInputs = [ nose covCore ];

  meta = with lib; {
    homepage = https://pypi.org/project/nose-cov/;
    license = licenses.mit;
    description = "This plugin produces coverage reports. It also supports coverage of subprocesses.";
    maintainers = with maintainers; [ ma27 ];
  };
}
