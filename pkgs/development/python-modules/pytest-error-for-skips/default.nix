{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-error-for-skips";
  version = "2.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jankatins";
    repo = pname;
    rev = version;
    sha256 = "04i4jd3bg4lgn2jfh0a0dzg3ml9b2bjv2ndia6b64w96r3r4p3qr";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_error_for_skips" ];

  meta = with lib; {
    description = "Pytest plugin to treat skipped tests a test failures";
    homepage = "https://github.com/jankatins/pytest-error-for-skips";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
