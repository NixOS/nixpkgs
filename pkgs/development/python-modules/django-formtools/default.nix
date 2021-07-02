{ stdenv, lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-formtools";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1chkbl188yj6hvhh1wgjpfgql553k6hrfwxzb8vv4lfdq41jq9y5";
  };

  propagatedBuildInputs = [ django ];
  checkPhase = ''
    python -m django test --settings=tests.settings
  '';

  meta = {
    description = "A set of high-level abstractions for Django forms";
    homepage = "https://github.com/jazzband/django-formtools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ greizgh schmittlauch ];
  };
}
