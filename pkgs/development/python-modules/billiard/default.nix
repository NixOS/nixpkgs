{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, pytestCheckHook
, case
, psutil
}:

buildPythonPackage rec {
  pname = "billiard";
  version = "3.6.4.0";
  disabled = isPyPy;

  src = fetchFromGitHub {
     owner = "celery";
     repo = "billiard";
     rev = "v3.6.4.0";
     sha256 = "1wg9sg8kcvhhqliq5dpgslcfw4xah67yjnrrz69lmk70lc32jkib";
  };

  checkInputs = [
    case
    psutil
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/celery/billiard";
    description = "Python multiprocessing fork with improvements and bugfixes";
    license = licenses.bsd3;
  };
}
