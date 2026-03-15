{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  imagecodecs,
  matplotlib,
  tifffile,
}:

buildPythonPackage (finalAttrs: {
  pname = "psdtags";
  version = "2026.1.29";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IzEX02BICa051sUrGKpL7+/BUkd4F2sWmO8IDD3cKP4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    all = [
      imagecodecs
      matplotlib
      tifffile
    ];
  };

  pythonImportsCheck = [
    "psdtags"
  ];

  meta = {
    description = "Read and write layered TIFF ImageSourceData and ImageResources tags";
    homepage = "https://pypi.org/project/psdtags";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ paperdigits ];
  };
})
