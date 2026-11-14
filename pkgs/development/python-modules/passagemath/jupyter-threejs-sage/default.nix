{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lib,
}:
buildPythonPackage rec {
  pname = "jupyter-threejs-sage";
  version = "122";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "passagemath";
    repo = "jupyter-threejs-sage";
    rev = "a607f4d3c2ecbba166b584c478019eb01c4628f1";
    inherit version;
    hash = "sha256-p/tTsfbCPLsndp1OPG6POQomf2cElzClnr0poKJBx+w=";
  };

  pythonImportsCheck = [ "jupyter_threejs_sage" ];

  meta = {
    description = "Custom build of Three.js for SageMath";
    longDescription = ''
      This package provides a single minified Javascript file `three.min.js`, which combines
standard Three.js with a number of scripts from `examples/jsm/`.

      The file is made available both as package data of a Python package `jupyter_threejs_sage` (for local access by SageMath) and as a Jupyter notebook extension (to be installed in the Jupyter notebook's Python environment).
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
