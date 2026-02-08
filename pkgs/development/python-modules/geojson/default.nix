{
  lib,
  fetchpatch,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "geojson";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "geojson";
    tag = finalAttrs.version;
    hash = "sha256-0p8FW9alcWCSdi66wanS/F9IgO714WIRQIXvg3f9op8=";
  };

  patches = [
    (fetchpatch {
      name = "allow-install-python314";
      url = "https://github.com/jazzband/geojson/commit/2584c0de5651bd694499449f9da5321b15597270.patch";
      hash = "sha256-64LPEwC1qc83wF48878fH31CVFn2txTmSxxr0cnQbRg=";
    })
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "geojson" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/jazzband/geojson";
    changelog = "https://github.com/jazzband/geojson/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
    teams = [ lib.teams.geospatial ];
  };
})
