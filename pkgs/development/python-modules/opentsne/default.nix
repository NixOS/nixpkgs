{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  numpy,
  oldest-supported-numpy,
  scipy,
  scikit-learn,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

let
  self = buildPythonPackage rec {
    pname = "opentsne";
    version = "1.0.1";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "pavlin-policar";
      repo = "openTSNE";
      rev = "refs/tags/v${version}";
      hash = "sha256-UTfEjjNz1mm5fhyTw9GRlMNURwWlr6kLMjrMngkFV3Y=";
    };

    nativeBuildInputs = [
      cython
      oldest-supported-numpy
      setuptools
      wheel
    ];

    propagatedBuildInputs = [
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
