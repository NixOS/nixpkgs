{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  matplotlib,
  tifffile,
}:

buildPythonPackage rec {
  pname = "roifile";
  version = "v2025.5.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgohlke";
    repo = "roifile";
    tag = version;
    hash = "sha256-SDsfiNrxWBR7QrGnz0voJEkgYc/oGXgs4t/szse2rFE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    all = [
      matplotlib
      tifffile
    ];
  };
  pythonImportsCheck = [
    "roifile"
  ];

  meta = {
    description = "Read and write ImageJ ROI format.";
    homepage = "https://github.com/cgohlke/roifile";
    changelog = "https://github.com/cgohlke/roifile/blob/master/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ afermg ];
    platforms = lib.platforms.all;
  };
}
