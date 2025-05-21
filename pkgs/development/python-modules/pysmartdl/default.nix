{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysmartdl";
  version = "1.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iTaybb";
    repo = "pySmartDL";
    tag = "v${version}";
    hash = "sha256-Etyv3xCB1cGozWDsskygwcTHJfC+V5hvqBNQAF8SIMM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://docs.python.org/3/whatsnew/3.13.html#unittest
  preCheck = ''
    substituteInPlace test/test_pySmartDL.py \
      --replace-fail 'unittest.makeSuite(' 'unittest.TestLoader().loadTestsFromTestCase('
  '';
  disabledTests = [
    # touch the network
    "test_basic_auth"
    "test_custom_headers"
    "test_download"
    "test_hash"
    "test_mirrors"
    "test_pause_unpause"
    "test_speed_limiting"
    "test_stop"
    "test_timeout"
    "test_unicode"
  ];

  pythonImportsCheck = [ "pySmartDL" ];

  meta = with lib; {
    homepage = "https://github.com/iTaybb/pySmartDL";
    description = "Smart Download Manager for Python";
    changelog = "https://github.com/iTaybb/pySmartDL/blob/${src.rev}/ChangeLog.txt";
    license = licenses.unlicense;
    maintainers = [ ];
  };
}
