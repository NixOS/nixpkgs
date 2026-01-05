{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XDw9mJW1Ubdjd5un23oDSH3B+OOzha+BmvNBrp725Io=";
  };

  # Test suite uses internal packaging._musllinux module to detect libc flavor. The module assumes
  # the python executable is dynamically linked - it then attempts to parse linked library name to
  # detect musl. It won't work on a static build.
  postPatch =
    if (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isStatic) then
      ''
        substituteInPlace netaddr/tests/__init__.py \
          --replace-fail "IS_MUSL = _get_musl_version(sys.executable) is not None" "IS_MUSL = True"
      ''
    else
      null;

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "netaddr" ];

  meta = {
    description = "Network address manipulation library for Python";
    mainProgram = "netaddr";
    homepage = "https://netaddr.readthedocs.io/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://github.com/netaddr/netaddr/blob/${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
