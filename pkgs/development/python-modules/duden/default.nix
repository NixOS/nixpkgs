{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  crayons,
  fetchFromGitHub,
  poetry-core,
  pyxdg,
  pyyaml,
  requests,
  setuptools,
  pytestCheckHook,
}:

let
  finalAttrs = {
    pname = "duden";
    version = "0.19.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "radomirbosak";
      repo = "duden";
      tag = finalAttrs.version;
      hash = "sha256-wjFIlwd4qG6aG9w0VPus6BGqghwIlPC6a8m0eagvIYM=";
    };

    build-system = [ poetry-core ];

    dependencies = [
      beautifulsoup4
      crayons
      pyxdg
      pyyaml
      requests
      setuptools
    ];

    nativeCheckInputs = [ pytestCheckHook ];

    disabledTestPaths = [
      "tests/test_online_attributes.py"
    ];

    pythonImportsCheck = [ "duden" ];

    meta = {
      homepage = "https://github.com/radomirbosak/duden";
      changelog = "https://github.com/radomirbosak/duden/blob/${finalAttrs.src.rev}/CHANGELOG.md";
      description = "CLI for https://duden.de dictionary written in Python";
      longDescription = ''
        duden is a CLI-based program and python module, which can provide
        various information about given german word. The provided data are
        parsed from german dictionary duden.de.
      '';
      license = with lib.licenses; [ mit ];
      mainProgram = "duden";
      maintainers = with lib.maintainers; [
        linuxissuper
      ];
    };
  };
in
buildPythonPackage finalAttrs
