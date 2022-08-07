{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, colorful
, tomlkit
, git
, packaging
, requests
}:

buildPythonPackage rec {
  pname = "pontos";
  version = "22.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JvmdxkgWIcXQ7ML1Sx6/YeH5WXyq/UCEZlTc9nJbcQQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorful
    tomlkit
    packaging
    requests
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'packaging = "^20.3"' 'packaging = "*"'
  '';

  disabledTests = [
    # Signing fails
    "test_find_no_signing_key"
    "test_find_signing_key"
    "test_find_unreleased_information"
    # CLI test fails
    "test_missing_cmd"
    "test_update_file_changed"
    # Network access
    "test_fail_sign_on_upload_fail"
    "test_successfully_sign"
  ];

  pythonImportsCheck = [
    "pontos"
  ];

  meta = with lib; {
    description = "Collection of Python utilities, tools, classes and functions";
    homepage = "https://github.com/greenbone/pontos";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
