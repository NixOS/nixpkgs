{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
, setuptools-scm

# dependencies
, redis

# tests
, pygments
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "2.8.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KwNap4KORsWOmzE5DuHxabmOEGarELmmqGH+fiXuTzM=";
  };

  postPatch = ''
    sed -i "/--cov/d" pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    redis
  ];

  nativeCheckInputs = [
    pygments
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "portalocker"
  ];

  meta = with lib; {
    changelog = "https://github.com/wolph/portalocker/releases/tag/v${version}";
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
  };
}
