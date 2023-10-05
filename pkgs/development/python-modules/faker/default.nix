{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, pytestCheckHook
, python-dateutil
, validators
}:

buildPythonPackage rec {
  pname = "faker";
  version = "19.6.2";

  src = fetchFromGitHub {
    owner = "joke2k";
    repo = "faker";
    rev = "v${version}";
    hash = "sha256-Ex1bGztYXoysdpkXbT4P3M9smBRjcwlURvkOKHYE6ss=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
    validators
  ];

  pythonImportsCheck = [ "faker" ];

  meta = with lib; {
    description = "Python library for generating fake user data";
    homepage = "https://faker.readthedocs.io";
    changelog = "https://github.com/joke2k/faker/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 mbalatsko ];
  };
}
