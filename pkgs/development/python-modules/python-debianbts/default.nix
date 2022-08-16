{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pysimplesoap
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SS2xxiaio25zz9NcrLiRPHNHEiFLBoTV8q3Fy67YYUk=";
  };

  propagatedBuildInputs = [ pysimplesoap ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "debianbts" ];

  meta = with lib; {
    description = "Python interface to Debian's Bug Tracking System";
    homepage = "https://github.com/venthur/python-debianbts";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
