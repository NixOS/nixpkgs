{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "refs/tags/v${version}";
    hash = "sha256-H3o2IWGuMqLrJTzQ7w636Ito6f57WBtMXpXXzrZ7UD8=";
  };

  # TODO: Properly unvendor miniaudio c library

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ cffi ];
  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miniaudio" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/irmen/pyminiaudio/releases/tag/v${version}";
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    changelog = "https://github.com/irmen/pyminiaudio/releases/tag/v${version}";
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
