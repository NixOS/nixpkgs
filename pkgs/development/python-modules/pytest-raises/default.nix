{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-raises";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "Lemmons";
    repo = pname;
    rev = version;
    sha256 = "0gbb4kml2qv7flp66i73mgb4qihdaybb6c96b5dw3mhydhymcsy2";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_raises" ];

  meta = with lib; {
    description = "An implementation of pytest.raises as a pytest.mark fixture";
    homepage = "https://github.com/Lemmons/pytest-raises";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
