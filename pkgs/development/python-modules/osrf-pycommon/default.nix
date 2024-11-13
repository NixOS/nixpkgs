{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flake8,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "osrf-pycommon";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osrf";
    repo = "osrf_pycommon";
    tag = version;
    hash = "sha256-NOedHm5ERwZHA16qfvoG5bfh+g1n6CXms9JbLvqRejg=";
  };

  build-system = [ setuptools ];

  checkInputs = [
    pytestCheckHook
    flake8
  ];

  pythonImportsCheck = [ "osrf_pycommon" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Commonly needed Python modules, used by Python software developed at OSRF";
    homepage = "https://github.com/osrf/osrf_pycommon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
}
