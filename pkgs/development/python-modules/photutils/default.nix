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
  photutils,
  pythonOlder,
  rasterio,
  scikit-image,
  scikit-learn,
  scipy,
  setuptools-scm,
  setuptools,
  shapely,
  tomli,
  tqdm,
  python,
  wheel,
}:

buildPythonPackage rec {
  pname = "photutils";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "photutils";
    rev = "refs/tags/${version}";
    hash = "sha256-k5MxpkCAvefSRoNPMAVIvNcCTU5HPicU4XSFXk13O9Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "'numpy>=2.0.0rc1'," ""
  '';

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
  ];

  passthru.optional-dependencies = {
    all = [
      bottleneck
      gwcs
      matplotlib
      rasterio
      scikit-image
      scikit-learn
      scipy
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
