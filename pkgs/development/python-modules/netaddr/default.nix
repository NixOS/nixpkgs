{
  lib,
<<<<<<< HEAD
  stdenv,
  buildPythonPackage,
  fetchPypi,
=======
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "1.3.0";
  pyproject = true;

<<<<<<< HEAD
=======
  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XDw9mJW1Ubdjd5un23oDSH3B+OOzha+BmvNBrp725Io=";
  };

<<<<<<< HEAD
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
=======
  nativeBuildInputs = [ setuptools ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "netaddr" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Network address manipulation library for Python";
    mainProgram = "netaddr";
    homepage = "https://netaddr.readthedocs.io/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://github.com/netaddr/netaddr/blob/${version}/CHANGELOG";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
