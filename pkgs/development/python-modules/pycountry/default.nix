{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "24.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pycountry";
    repo = "pycountry";
    tag = version;
    hash = "sha256-4YVPh6OGWguqO9Ortv+vAejxx7WLs4u0SVLv8JlKSWM=";
  };

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
    sed -i "/pytest-cov/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycountry" ];

  meta = {
    homepage = "https://github.com/pycountry/pycountry";
    changelog = "https://github.com/pycountry/pycountry/blob/${src.rev}/HISTORY.txt";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
