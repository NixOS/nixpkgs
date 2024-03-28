{ lib
, stdenv
, buildPythonPackage
, fetchFromGitLab
, ghostscript_headless
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ghostscript";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "pdftools";
    repo = "python-ghostscript";
    rev = "v${version}";
    hash = "sha256-yBJuAnLK/4YDU9PBsSWPQay4pDws3bP+3rCplysq41w=";
  };

  # AttributeError: module 'ghostscript' has no attribute '__version__'
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "attr:ghostscript.__version__" ${version}
    substituteInPlace ghostscript/_gsprint.py \
      --replace 'cdll.LoadLibrary("libgs.so")' "cdll.LoadLibrary('${ghostscript_headless}/lib/libgs${stdenv.hostPlatform.extensions.sharedLibrary}')"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [
    ghostscript_headless
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # flaky test that fails because 2 or 3 pixels cannot be reproduced
    "test_simple"
    "test_unicode_arguments"
    "test_run_string"
    "test_stdin"
    "test_run_string"
    "test_simple"
    "test_stdin"
  ];

  pythonImportsCheck = [ "ghostscript" ];

  meta = with lib; {
    description = "Interface to the Ghostscript C-API";
    homepage = "https://gitlab.com/pdftools/python-ghostscript";
    changelog = "https://gitlab.com/pdftools/python-ghostscript/-/blob/${src.rev}/CHANGES.txt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natsukium ];
  };
}
