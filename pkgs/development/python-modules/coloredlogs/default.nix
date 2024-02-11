{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, humanfriendly
, verboselogs
, capturer
, pytestCheckHook
, mock
, util-linux
}:

buildPythonPackage rec {
  pname = "coloredlogs";
  version = "15.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-coloredlogs";
    rev = version;
    hash = "sha256-TodI2Wh8M0qMM2K5jzqlLmUKILa5+5qq4ByLttmAA7E=";
  };

  propagatedBuildInputs = [
    humanfriendly
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    util-linux
    verboselogs
    capturer
  ];

  # capturer is broken on darwin / py38, so we skip the test until a fix for
  # https://github.com/xolox/python-capturer/issues/10 is released.
  doCheck = !stdenv.isDarwin;

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
    homepage = "https://github.com/xolox/python-coloredlogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
