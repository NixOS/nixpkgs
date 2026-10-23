{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "26.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycountry";
    repo = "pycountry";
    tag = version;
    hash = "sha256-VmPCQszEaDNsSnMfAo5xyDZySJcC4TiWZrmQMfebKKQ=";
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
    changelog = "https://github.com/pycountry/pycountry/blob/${src.tag}/HISTORY.txt";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
