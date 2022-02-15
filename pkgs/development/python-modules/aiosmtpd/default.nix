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
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = version;
    sha256 = "0hbpyns1j1fpvpj7gyb8cz359j7l4hzfqbig74xp4xih59sih0wj";
  };

  propagatedBuildInputs = [
    atpublic
    attrs
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  # Fixes for Python 3.10 can't be applied easily, https://github.com/aio-libs/aiosmtpd/pull/294
  doCheck = pythonOlder "3.10";

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
    longDescription = ''
      This is a server for SMTP and related protocols, similar in utility to the
      standard library's smtpd.py module.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
