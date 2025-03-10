{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  biopython,
  matplotlib,
  scipy,
}:

buildPythonPackage rec {
  pname = "graphlan";
  version = "0-unstable-2024-08-07";

  pyproject = true;
  build-system = [ setuptools ];

  patchPhase = ''
    sed -i 's|biopython==|biopython>=|' setup.py
  '';

  dependencies = [
    biopython
    matplotlib
    scipy
  ];

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "graphlan";
    rev = "dc97f4feb0bb0bf3fa210e2699a86c5e476a647e";
    hash = "sha256-sBVlBu6RSs7dXQbxJrIQHWaDNliurY9UguzNeKj40gY=";
  };

  meta = {
    description = "Quality control tool for metagenomic and metatranscriptomic sequencing data";
    homepage = "https://github.com/biobakery/graphlan";
    changelog = "https://github.com/biobakery/graphlan/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "graphlan.py";
  };
}
