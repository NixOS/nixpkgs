{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-memcached";
  version = "1.62";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linsomniac";
    repo = "python-memcached";
    rev = version;
    hash = "sha256-Qko4Qr9WofeklU0uRRrSPrT8YaBYMCy0GP+TF7YZHLI=";
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
