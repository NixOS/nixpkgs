{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  pythonOlder,
  hatchling,
  hatch-vcs,
  numpy,
  packaging,
  importlib-resources,
  typing-extensions,
  pydicom,
  pillow,
  h5py,
  scipy,
  git,
  pytest-doctestplus,
  pytest-httpserver,
  pytest-xdist,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "5.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C9ymUDsceEtEbHRaRUI2fed1bPug1yFDuR+f+3i+Vps=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/nipy/nibabel/commit/3f40a3bc0c4bd996734576a15785ad0f769a963a.patch?full_index=1";
      hash = "sha256-URsxgP6Sd5IIOX20GtAYtWBWOhw+Hiuhgu1oa8o8NXk=";
    })
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    numpy
    packaging
  ]
  ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ]
  ++ lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  optional-dependencies = rec {
    all = dicom ++ dicomfs ++ minc2 ++ spm ++ zstd;
    dicom = [ pydicom ];
    dicomfs = [ pillow ] ++ dicom;
    minc2 = [ h5py ];
    spm = [ scipy ];
    zstd = [
      # TODO: pyzstd
    ];
  };

  nativeCheckInputs = [
    git
    pytest-doctestplus
    pytest-httpserver
    pytest-xdist
    pytest7CheckHook
  ]
  ++ optional-dependencies.all;

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
