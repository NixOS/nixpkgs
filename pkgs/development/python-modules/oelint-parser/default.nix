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
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = "oelint-parser";
    tag = version;
    hash = "sha256-NTMAgAN/YJu8vdk1AV4Ji962MIq4Wf5w+0yryz9cLh4=";
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
    changelog = "https://github.com/priv-kweihmann/oelint-parser/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
