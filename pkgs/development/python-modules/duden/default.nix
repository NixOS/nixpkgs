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
}:

let
  finalAttrs = {
    pname = "duden";
    version = "0.19.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "radomirbosak";
      repo = "duden";
      rev = finalAttrs.version;
      hash = "sha256-c6IItrjFVbsdYg3sDrExcxv7aRcKhd/M5hiZD+wBZ2Y=";
    };

    nativeBuildInputs = [ poetry-core ];

    propagatedBuildInputs = [
      beautifulsoup4
      crayons
      pyxdg
      pyyaml
      requests
      setuptools
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
        AndersonTorres
        linuxissuper
      ];
    };
  };
in
buildPythonPackage finalAttrs
