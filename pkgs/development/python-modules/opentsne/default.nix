{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  scipy,
  scikit-learn,
  pytestCheckHook,
  setuptools,
}:

let
  self = buildPythonPackage rec {
    pname = "opentsne";
    version = "1.0.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pavlin-policar";
      repo = "openTSNE";
      tag = "v${version}";
      hash = "sha256-cGnhdGpDiBlTeeveCtnveslDytpNO8vtYkxQQ7FhsuA=";
    };

    build-system = [
      cython
      numpy
      setuptools
    ];

    dependencies = [
      numpy
      scipy
      scikit-learn
    ];

    pythonImportsCheck = [ "openTSNE" ];

    doCheck = false;

    passthru = {
      tests.pytest = self.overridePythonAttrs (old: {
        pname = "${old.pname}-tests";
        pyproject = false;

        postPatch = "rm openTSNE -rf";

        doBuild = false;
        doInstall = false;

        doCheck = true;
        nativeCheckInputs = [
          pytestCheckHook
          self
        ];
      });
    };

    meta = {
      description = "Modular Python implementation of t-Distributed Stochasitc Neighbor Embedding";
      homepage = "https://github.com/pavlin-policar/openTSNE";
      changelog = "https://github.com/pavlin-policar/openTSNE/releases/tag/v${version}";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ lucasew ];
    };
  };
in
self
