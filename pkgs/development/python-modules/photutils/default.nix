{
  lib,
  astropy,
  bottleneck,
  buildPythonPackage,
  cython,
  extension-helpers,
  fetchFromGitHub,
  gwcs,
  matplotlib,
  numpy,
  pythonOlder,
  rasterio,
  scikit-image,
  scikit-learn,
  scipy,
  setuptools-scm,
  setuptools,
  shapely,
  tqdm,
  wheel,
}:

buildPythonPackage rec {
  pname = "photutils";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "photutils";
    tag = version;
    hash = "sha256-p1MQgIYmiTekKV6oNKql/dnp5CAahXzecrTl25tz1g0=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeBuildInputs = [
    cython
    extension-helpers
    numpy
  ];

  dependencies = [
    astropy
    numpy
    scipy
  ];

  optional-dependencies = {
    all = [
      bottleneck
      gwcs
      matplotlib
      rasterio
      scikit-image
      scikit-learn
      shapely
      tqdm
    ];
  };

  # With 1.12.0 tests have issues importing modules
  doCheck = false;

  pythonImportsCheck = [ "photutils" ];

  meta = with lib; {
    description = "Astropy package for source detection and photometry";
    homepage = "https://github.com/astropy/photutils";
    changelog = "https://github.com/astropy/photutils/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
