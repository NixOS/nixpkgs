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
  version = "5.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jSAGtw1yf9CnmKiK5f1kM5dB9Db8/IPW6jJWzbxRxbc=";
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

  meta = {
    homepage = "https://nipy.org/nibabel";
    changelog = "https://github.com/nipy/nibabel/blob/${version}/Changelog";
    description = "Access a multitude of neuroimaging data formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
