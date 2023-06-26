{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, h5py
, nibabel
, numpy
, scipy
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "nitransforms";
  version = "23.0.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jzb0W3HHxkNPyPcAT2G9T8zLOfq7xQTwGA6IUO5a6KA=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  buildInputs = [ setuptools-scm toml ];
  propagatedBuildInputs = [ h5py nibabel numpy scipy ];

  pythonRelaxDeps = [ "scipy" ];

  doCheck = false;
  # relies on data repo (https://github.com/nipreps-data/nitransforms-tests);
  # probably too heavy
  pythonImportsCheck = [
    "nitransforms"
    "nitransforms.base"
    "nitransforms.io"
    "nitransforms.io.base"
    "nitransforms.linear"
    "nitransforms.manip"
    "nitransforms.nonlinear"
    "nitransforms.patched"
  ];

  meta = with lib; {
    homepage = "https://nitransforms.readthedocs.io";
    description = "Geometric transformations for images and surfaces";
    changelog = "https://github.com/nipy/nitransforms/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
