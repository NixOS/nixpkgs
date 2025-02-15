{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  mo-installer,

  pytestCheckHook,
  python-dateutil,
  mock,
  pymongo,
  coverage,
}:
let
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "schematics";
    repo = "schematics";
    rev = "refs/tags/v${version}";
    hash = "sha256-jclKcX/4QbRCuWKdKq97Wo3q10Rbkt7/R8AJQTwnwVk=";
  };
in
buildPythonPackage {
  pname = "schematics";
  inherit version src;
  pyproject = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = [
    setuptools
    mo-installer
  ];

  pythonImportsCheck = [ "schematics" ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    mock
    pymongo
    coverage
  ];

  meta = {
    description = "Python Data Structures for Humans";
    homepage = "https://schematics.readthedocs.io/";
    changelog = "https://github.com/s-ball/mo_installer/blob/${src.rev}/HISTORY.rst";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
