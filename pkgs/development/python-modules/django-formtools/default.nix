{ stdenv, lib, buildPythonPackage, fetchPypi, django, python }:

buildPythonPackage rec {
  pname = "django-formtools";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1chkbl188yj6hvhh1wgjpfgql553k6hrfwxzb8vv4lfdq41jq9y5";
  };

  propagatedBuildInputs = [ django ];
  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "A set of high-level abstractions for Django forms";
    homepage = "https://github.com/jazzband/django-formtools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
