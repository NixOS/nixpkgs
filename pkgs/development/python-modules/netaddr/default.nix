{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XDw9mJW1Ubdjd5un23oDSH3B+OOzha+BmvNBrp725Io=";
  };

  # Test suite uses internal packaging._musllinux module to detect libc flavor. The module assumes
  # the python executable is dynamically linked - it then attempts to parse linked library name to
  # detect musl. It won't work on a static build.
  postPatch = lib.optionalString (stdenv.targetPlatform.isMusl && stdenv.targetPlatform.isStatic) ''
    sed -i "s/IS_MUSL = .*/IS_MUSL = True/" netaddr/tests/__init__.py
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "netaddr" ];

  meta = with lib; {
    description = "Network address manipulation library for Python";
    mainProgram = "netaddr";
    homepage = "https://netaddr.readthedocs.io/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://github.com/netaddr/netaddr/blob/${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
