{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  gmt,
  numpy,
  pandas,
  packaging,
  xarray,
  pytest-mpl,
  ipython,
  ghostscript,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygmt";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yWB/IRu5B6hnu8e1TvpAaLehr1TMqvnDc5sRgyMw2mM=";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace-fail "env.get(\"GMT_LIBRARY_PATH\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    numpy
    pandas
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    ghostscript
    ipython
  ];

  # The *entire* test suite requires network access
  doCheck = false;

  postBuild = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [ "pygmt" ];

  meta = {
    description = "Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = lib.licenses.bsd3;
    changelog = "https://github.com/GenericMappingTools/pygmt/releases/tag/${finalAttrs.src.tag}";
    teams = [ lib.teams.geospatial ];
  };
})
