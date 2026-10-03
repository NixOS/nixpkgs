{
  python3,
  lib,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "xenomapper";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "genomematt";
    repo = "xenomapper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Gf6x3lgS07o4pq2mz7yEHK1dUp+r4Ia+gRHWgul31VY=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ statistics ];

  pythonImportsCheck = [
    "xenomapper.xenomapper"
    "xenomapper.mappability"
  ];

  meta = {
    homepage = "https://github.com/genomematt/xenomapper";
    description = "Utility for post processing mapped reads that have been aligned to a primary genome and a secondary genome and binning reads into species specific, multimapping in each species, unmapped and unassigned bins";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jbedo ];
  };
})
