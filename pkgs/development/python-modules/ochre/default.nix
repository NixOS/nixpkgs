{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ochre";
  version = "0.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "getcuia";
    repo = "ochre";
    rev = "v${version}";
    hash = "sha256-U6qycLnldwNze3XMAn6DS3XGX4RaCZgW0pH/y/FEAkk=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ochre" ];

  meta = with lib; {
    description = "Down-to-earth approach to colors";
    homepage = "https://github.com/getcuia/ochre";
    changelog = "https://github.com/getcuia/ochre/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
