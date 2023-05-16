{ lib
, buildPythonPackage
, fetchPypi
, celery
, humanize
, pytz
, tornado
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flower";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-WrcXuXlTB3DBavtItQ0qmNI8Pp/jmFHc9rxNAYRaAqA=";
=======
    sha256 = "46493c7e8d9ca2167e8a46eb97ae8d280997cb40a81993230124d74f0fe40bac";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # rely on using example programs (flowers/examples/tasks.py) which
    # are not part of the distribution
    rm tests/load.py
  '';

  propagatedBuildInputs = [
    celery
    humanize
    prometheus-client
    pytz
    tornado
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flower"
  ];

  meta = with lib; {
    description = "Real-time monitor and web admin for Celery distributed task queue";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
