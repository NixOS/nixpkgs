{ lib
, atpublic
, attrs
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiosmtpd";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QtLtw+2jEPLOxa45vDEbWEaSZ8RIyxf1zkZjR34Wu+8=";
  };

  propagatedBuildInputs = [
    atpublic
    attrs
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Requires git
    "test_ge_master"
    # Seems to be a sandbox issue
    "test_byclient"
  ];

  pythonImportsCheck = [
    "aiosmtpd"
  ];

  meta = with lib; {
    description = "Asyncio based SMTP server";
    homepage = "https://aiosmtpd.readthedocs.io/";
    changelog = "https://github.com/aio-libs/aiosmtpd/releases/tag/${version}";
    longDescription = ''
      This is a server for SMTP and related protocols, similar in utility to the
      standard library's smtpd.py module.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
