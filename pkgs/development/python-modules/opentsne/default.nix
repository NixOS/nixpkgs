{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, numpy
, oldest-supported-numpy
, scipy
, scikit-learn
, pytestCheckHook
, nix-update-script
, setuptools
, wheel
}:

let
  self = buildPythonPackage rec {
    pname = "opentsne";
    version = "1.0.0";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "pavlin-policar";
      repo = "openTSNE";
      rev = "v${version}";
      hash = "sha256-L5Qx6dMJlXF3EaWwlFTQ3dkhGXc5PvQBXYJo+QO+Hxc=";
    };

    nativeBuildInputs = [
      cython
      oldest-supported-numpy
      setuptools
      wheel
    ];

    propagatedBuildInputs = [ numpy scipy scikit-learn ];

    pythonImportsCheck = [ "openTSNE" ];
    doCheck = false;

    passthru = {
      updateScript = nix-update-script {};
      tests.pytest = self.overridePythonAttrs (old: {
        pname = "${old.pname}-tests";
        format = "other";

        postPatch = "rm openTSNE -rf";

        doBuild = false;
        doInstall = false;

        doCheck = true;
        nativeCheckInputs = [ pytestCheckHook self ];
      });
    };

    meta = {
      description = "Modular Python implementation of t-Distributed Stochasitc Neighbor Embedding";
      homepage = "https://github.com/pavlin-policar/openTSNE";
      changelog = "https://github.com/pavlin-policar/openTSNE/releases/tag/${version}";
      license = [ lib.licenses.bsd3 ];
      maintainers = [ lib.maintainers.lucasew ];
    };
  };
in self
