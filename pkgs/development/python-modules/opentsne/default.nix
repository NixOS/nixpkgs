{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  scipy,
  scikit-learn,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

let
  self = buildPythonPackage rec {
    pname = "opentsne";
    version = "1.0.3";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "pavlin-policar";
      repo = "openTSNE";
      tag = "v${version}";
      hash = "sha256-dJM8hv85ST5qGo/oZVr/MgIHGPGpZ+ajaUL7pfSJLAg=";
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
        format = "other";

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

    meta = with lib; {
      description = "Modular Python implementation of t-Distributed Stochasitc Neighbor Embedding";
      homepage = "https://github.com/pavlin-policar/openTSNE";
      changelog = "https://github.com/pavlin-policar/openTSNE/releases/tag/v${version}";
      license = licenses.bsd3;
      maintainers = with maintainers; [ lucasew ];
    };
  };
in
self
