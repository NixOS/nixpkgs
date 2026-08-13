{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  mpv,
  setuptools,
  pytestCheckHook,
  pyvirtualdisplay,
  writableTmpDirAsHomeHook,
  xvfb,
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    tag = "v${version}";
    hash = "sha256-MHdQnnjxnbOkIf56VLGi7vgNbrjhU/ODUBdZoXjxXxE=";
  };

  postPatch = ''
    substituteInPlace mpv.py \
      --replace-fail "sofile = ctypes.util.find_library('mpv')" \
                     'sofile = "${mpv}/lib/libmpv${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [ setuptools ];

  buildInputs = [ mpv ];

  nativeCheckInputs = [
    pytestCheckHook
    pyvirtualdisplay
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xvfb
  ];

  disabledTestPaths = [
    # timing sensitive
    "tests/test_mpv.py::CommandTests::test_sub_add"

    # flaky
    "tests/test_mpv.py::ObservePropertyTest::test_property_observer_decorator"
    "tests/test_mpv.py::RegressionTests::test_wait_for_property_concurrency"
  ];

  pythonImportsCheck = [ "mpv" ];

  meta = {
    description = "Python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
