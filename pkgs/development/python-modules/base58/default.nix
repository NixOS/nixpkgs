{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhamcrest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "base58";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xdDLP1tugejjXaV1Q4jdzG0NFLbGoTLLk9ae1YCnJ4w=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
  ];

  disabledTests = [
    # avoid dependency on pytest-benchmark
    "test_decode_random"
    "test_encode_random"
  ];

  pythonImportsCheck = [ "base58" ];

<<<<<<< HEAD
  meta = {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    changelog = "https://github.com/keis/base58/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
=======
  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    changelog = "https://github.com/keis/base58/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "base58";
  };
}
