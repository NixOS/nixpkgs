{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, domdf-python-tools
, handy-archives
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dist-meta";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "dist-meta";
    rev = "v${version}";
    hash = "sha256-0209sZ3DHtKhc6Rb9x6b6/KF8is2Xl+T+oHSy9xjXn8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    domdf-python-tools
    handy-archives
    packaging
  ];

  pythonImportsCheck = [ "dist_meta" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Parse and create Python distribution metadata";
    homepage = "https://github.com/repo-helper/dist-meta";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
