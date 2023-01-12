{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytestCheckHook
, pythonOlder
, srsly
}:

buildPythonPackage rec {
  pname = "confection";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JZQ9D5+UAobywlj8eiyw15wXKYhUKz6+lf9hikMV6x0=";
  };

  propagatedBuildInputs = [
    pydantic
    srsly
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "confection"
  ];

  meta = with lib; {
    description = "Library that offers a configuration system";
    homepage = "https://github.com/explosion/confection";
    changelog  = "https://github.com/explosion/confection/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
