{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, hatch-vcs
, numpy
, packaging
, importlib-resources
, pydicom
, pillow
, h5py
, scipy
, git
, pytest-doctestplus
, pytest-httpserver
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pfjxq5gdG9kvQzHVZVKNEmq5cX/b1M/mj0P80cK/P1I=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    numpy
    packaging
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  passthru.optional-dependencies = rec {
    all = dicom
      ++ dicomfs
      ++ minc2
      ++ spm
      ++ zstd;
    dicom = [
      pydicom
    ];
    dicomfs = [
      pillow
    ] ++ dicom;
    minc2 = [
      h5py
    ];
    spm = [
      scipy
    ];
    zstd = [
      # TODO: pyzstd
    ];
  };

  nativeCheckInputs = [
    git
    pytest-doctestplus
    pytest-httpserver
    pytest-xdist
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    homepage = "https://nipy.org/nibabel";
    changelog = "https://github.com/nipy/nibabel/blob/${version}/Changelog";
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
