{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  pytestCheckHook,
  python-utils,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lap";
  version = "0.5.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VwtBTqeubAS9SdDsjNrB3FY0c3dVeE1E43+fZourRP0=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    numpy
    python-utils
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lap" ];
  # See https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd "$out"
  '';

  meta = {
    description = "Linear Assignment Problem solver (LAPJV/LAPMOD)";
    homepage = "https://github.com/gatagat/lap";
    changelog = "https://github.com/gatagat/lap/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      doronbehar
      tebriel
    ];
  };
}
