{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cffi
, pillow
, pytestCheckHook
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "blurhash-python";
  version = "1.2.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "woltapp";
    repo = "blurhash-python";
    rev = "v${version}";
    hash = "sha256-z7V2Ck8h12Vuj/5/s9ZP/uqQ4olo8xwg+ZR3iW4ca/M=";
  };

  nativeBuildInputs = [
    cffi
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cffi
    pillow
    six
  ];

  pythonImportsCheck = [ "blurhash" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Compact representation of a placeholder for an image";
    homepage = "https://github.com/woltapp/blurhash-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
