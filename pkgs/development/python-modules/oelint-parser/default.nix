{
  lib,
  nix-update-script,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  deprecated,
  regex,
  pytest-cov-stub,
  pytest-forked,
  pytest-random-order,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oelint-parser";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-7LEjo/Z9mk2gx2vzDKz5cFR5bDTDgjIVVOquj0o/+0I=";
  };

  pythonRelaxDeps = [ "regex" ];

  build-system = [ setuptools ];

  dependencies = [
    regex
    deprecated
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-forked
    pytest-random-order
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oelint_parser" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative parser for bitbake recipes";
    homepage = "https://github.com/priv-kweihmann/oelint-parser";
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
