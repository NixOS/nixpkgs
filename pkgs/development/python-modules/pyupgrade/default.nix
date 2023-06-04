{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HxtjqZsYG8Xp9WcJWVkYy7gYJ1WvdVztd5zqZObJ1rw=";
  };

  propagatedBuildInputs = [
    tokenize-rt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyupgrade"
  ];

  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
