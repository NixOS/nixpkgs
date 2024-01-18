{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-memcached";
  version = "1.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linsomniac";
    repo = "python-memcached";
    rev = version;
    hash = "sha256-7bUCVAmOJ6znVmTZg9AJokOuym07NHL12gZgQ2uhfNo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  # all tests fail
  doCheck = false;

  pythonImportsCheck = [ "memcache" ];

  meta = with lib; {
    description = "Pure python memcached client";
    homepage = "https://github.com/linsomniac/python-memcached";
    license = licenses.psfl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
