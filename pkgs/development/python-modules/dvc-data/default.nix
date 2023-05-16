{ lib
, buildPythonPackage
, dictdiffer
, diskcache
, dvc-objects
, fetchFromGitHub
, funcy
<<<<<<< HEAD
=======
, nanotime
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pygtrie
, pythonOlder
, setuptools-scm
, shortuuid
, sqltrie
}:

buildPythonPackage rec {
  pname = "dvc-data";
<<<<<<< HEAD
  version = "2.16.1";
=======
  version = "0.49.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-hnKOSo/RUzGnj7JbdKOGogVN925LZQiL3uvy5+dQfPw=";
=======
    hash = "sha256-+bVDfjfWLJKCYVM5B0cy5E7hzdjHQSG/UIHaxus4D6E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dictdiffer
    diskcache
    dvc-objects
    funcy
<<<<<<< HEAD
=======
    nanotime
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pygtrie
    shortuuid
    sqltrie
  ];

  # Tests depend on upath which is unmaintained and only available as wheel
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "dvc-objects==" "dvc-objects>="
  '';

  pythonImportsCheck = [
    "dvc_data"
  ];

  meta = with lib; {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
