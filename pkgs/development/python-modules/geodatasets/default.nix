{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  geopandas,
  pooch,
  pyogrio,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "geodatasets";
<<<<<<< HEAD
  version = "2025.12.1";
  pyproject = true;
=======
  version = "2024.8.0";
  pyproject = true;
  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-r5dHWJ6HH6capBOXg/pgeHXPmzLPvXLD27u7AELdIaU=";
=======
    hash = "sha256-GJ7RyFlohlRz0RbQ80EewZUmIX9CJkSfUMY/uMNTtEM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

<<<<<<< HEAD
  dependencies = [ pooch ];
=======
  propagatedBuildInputs = [ pooch ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    geopandas
    pyogrio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestMarks = [
    # disable tests which require network access
    "request"
  ];

  pythonImportsCheck = [ "geodatasets" ];

  meta = {
    description = "Spatial data examples";
    homepage = "https://geodatasets.readthedocs.io/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
