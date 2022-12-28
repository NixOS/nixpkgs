{ lib
, buildPythonPackage
, dictdiffer
, diskcache
, dvc-objects
, fetchFromGitHub
, funcy
, nanotime
, pygtrie
, pythonOlder
, shortuuid
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-data";
  version = "0.1.13";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dKqn7dMwPxKnLLBPJGgmD/2MFzdzrw7W9+w9Zi/9hsA=";
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
    nanotime
    pygtrie
    shortuuid
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
