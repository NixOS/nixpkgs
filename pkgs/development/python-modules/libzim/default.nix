{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  cython,
  pkg-config,
  libzim,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "libzim";
  version = "3.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Rt2A5d6hTxT13OqBNZifIw5Hc6jLJv1jL7d1bFObZRY=";
  };

  # Upstream pins exact build tool versions and by default downloads a prebuilt
  # libzim. Build against the system one instead; ctypes.util.find_library
  # cannot locate it in the sandbox, so hand setup.py the store path.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools == 84.0.0"' '"setuptools"' \
      --replace-fail '"wheel == 0.48.0"' '"wheel"' \
      --replace-fail '"cython == 3.3.0"' '"cython"'
    substituteInPlace setup.py \
      --replace-fail 'find_library("zim") or ""' '"${lib.getLib libzim}/lib/libzim.so"'
  '';

  env.USE_SYSTEM_LIBZIM = "1";

  build-system = [
    setuptools
    wheel
    cython
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libzim ];

  nativeCheckInputs = [ pytestCheckHook ];

  # These tests download sample ZIM files from GitHub.
  disabledTestPaths = [ "tests/test_libzim_reader.py" ];

  pythonImportsCheck = [
    "libzim"
    "libzim.reader"
    "libzim.search"
    "libzim.writer"
  ];

  meta = {
    description = "Python bindings for libzim, the reference implementation of the ZIM file format";
    homepage = "https://github.com/openzim/python-libzim";
    changelog = "https://github.com/openzim/python-libzim/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ harvest316 ];
  };
})
