{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  numpy,
  pytestCheckHook,

  # optional/test dependencies
  gdcm,
  pillow,
  pydicom,
  pyjpegls,
  pylibjpeg,
  pylibjpeg-libjpeg,
  writableTmpDirAsHomeHook,
}:
let
  # Pydicom needs pydicom-data to run some tests. If these files aren't downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "8da482f208401d63cd63f3f4efc41b6856ef36c7";
    hash = "sha256-ji7SppKdiszaXs8yCSIPkJj4Ld++XWNw9FuxLoFLfFo=";
  };
in
buildPythonPackage rec {
  pname = "pydicom";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom";
    tag = "v${version}";
    hash = "sha256-SvRevQehRaSp+vCtJRQVEJiC5noIJS+bGG1/q4p7/XU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    pixeldata = [
      pillow
      pyjpegls
      pylibjpeg
      pylibjpeg-libjpeg
      gdcm
    ]
    ++ pylibjpeg.optional-dependencies.openjpeg
    ++ pylibjpeg.optional-dependencies.rle;
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.pixeldata;

  passthru.pydicom-data = test_data;

  doCheck = false; # circular dependency

  passthru.tests.pytest = pydicom.overridePythonAttrs {
    doCheck = true;
  };

  # Setting $HOME to prevent pytest to try to create a folder inside
  # /homeless-shelter which is read-only.
  # Linking pydicom-data dicom files to $HOME/.pydicom/data
  preCheck = ''
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  disabledTests = [
    # tries to remove a dicom inside $HOME/.pydicom/data/ and download it again
    "test_fetch_data_files"

    # test_reference_expl{,_binary}[parametric_map_float.dcm] tries to download that file for some reason even though it's present in test-data
    "test_reference_expl"
    "test_reference_expl_binary"

    # slight error in regex matching
    "test_no_decoders_raises"
    "test_deepcopy_bufferedreader_raises"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # https://github.com/pydicom/pydicom/issues/1386
    "test_array"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky, hard to reproduce failure outside hydra
    "test_time_check"
  ];

  pythonImportsCheck = [ "pydicom" ];

  meta = {
    description = "Python package for working with DICOM files";
    mainProgram = "pydicom";
    homepage = "https://pydicom.github.io";
    changelog = "https://github.com/pydicom/pydicom/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    badPlatforms = [
      # > 200 tests are failing with errors like:
      # AttributeError: 'FileDataset' object has no attribute 'BitsStored'
      # AttributeError: 'FileDataset' object has no attribute 'Rows'
      # AttributeError: The dataset has no 'Pixel Data', 'Float Pixel Data' or 'Double Float Pixel Data' element, no pixel data to decode
      # pydicom.errors.InvalidDicomError: File is missing DICOM File Meta Information header or the 'DICM' prefix is missing from the header.
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
