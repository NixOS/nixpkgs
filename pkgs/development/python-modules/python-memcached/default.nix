{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-memcached";
  version = "1.61";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linsomniac";
    repo = "python-memcached";
    rev = "refs/tags/${version}";
    hash = "sha256-7bUCVAmOJ6znVmTZg9AJokOuym07NHL12gZgQ2uhfNo=";
  };

  propagatedBuildInputs = [
    six
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
