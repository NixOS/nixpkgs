{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  gssapi,
  krb5,
  ruamel-yaml,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "pyspnego";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "pyspnego";
    tag = "v${version}";
    hash = "sha256-dkss+8Z0dS4MTunBZWEH+WK1+kGikCHf7VPCR1reMS0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ cryptography ];

  optional-dependencies = {
    kerberos = [
      gssapi
      krb5
    ];
    yaml = [ ruamel-yaml ];
  };

  pythonImportsCheck = [ "spnego" ];

  nativeCheckInputs = [
    glibcLocales
    pytest-mock
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    changelog = "https://github.com/jborean93/pyspnego/blob/${src.tag}/CHANGELOG.md";
    description = "Python SPNEGO authentication library";
    mainProgram = "pyspnego-parse";
    homepage = "https://github.com/jborean93/pyspnego";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
