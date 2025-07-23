{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jgehrcke";
    repo = "gipc";
    tag = version;
    hash = "sha256-eYE7A1VDJ0NSshvdJKxPwGyVdW6BnyWoRSR1i1iTr8Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "gevent>=1.5,<=23.9.1" "gevent>=1.5"
  '';

  build-system = [ setuptools ];

  dependencies = [ gevent ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gipc" ];

  disabledTests = [
    # AttributeError
    "test_all_handles_length"
    "test_child"
    "test_closeread"
    "test_closewrite"
    "test_early_readchild_exit"
    "test_handlecount"
    "test_handler"
    "test_onewriter"
    "test_readclose"
    "test_singlemsg"
    "test_twochannels_singlemsg"
    "test_twoclose"
    "test_twowriters"
    "test_write_closewrite_read"
  ];

  meta = with lib; {
    description = "Gevent-cooperative child processes and IPC";
    longDescription = ''
      Usage of Python's multiprocessing package in a gevent-powered
      application may raise problems and most likely breaks the application
      in various subtle ways. gipc (pronunciation "gipsy") is developed with
      the motivation to solve many of these issues transparently. With gipc,
      multiprocessing. Process-based child processes can safely be created
      anywhere within your gevent-powered application.
    '';
    homepage = "http://gehrcke.de/gipc";
    changelog = "https://github.com/jgehrcke/gipc/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
