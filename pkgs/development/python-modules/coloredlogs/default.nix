{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  humanfriendly,
  verboselogs,
  capturer,
  pytestCheckHook,
  mock,
  util-linux,
}:

buildPythonPackage rec {
  pname = "coloredlogs";
  version = "15.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-coloredlogs";
    rev = version;
    hash = "sha256-TodI2Wh8M0qMM2K5jzqlLmUKILa5+5qq4ByLttmAA7E=";
  };

  patches = [
    # https://github.com/xolox/python-coloredlogs/pull/120
    (fetchpatch2 {
      name = "python313-compat.patch";
      url = "https://github.com/xolox/python-coloredlogs/commit/9d4f4020897fcf48d381de8e099dc29b53fc9531.patch?full_index=1";
      hash = "sha256-Z7MYzyoQBMLBS7c0r5zITuHpl5yn4Vg7Xf/CiG7jTSs=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ humanfriendly ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    util-linux
    verboselogs
    capturer
  ];

  # capturer is broken on darwin / py38, so we skip the test until a fix for
  # https://github.com/xolox/python-capturer/issues/10 is released.
  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    # Required for the CLI test
    PATH=$PATH:$out/bin
  '';

  disabledTests = [
    "test_plain_text_output_format"
    "test_auto_install"
  ];

  pythonImportsCheck = [ "coloredlogs" ];

  meta = with lib; {
    description = "Colored stream handler for Python's logging module";
    mainProgram = "coloredlogs";
    homepage = "https://github.com/xolox/python-coloredlogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
