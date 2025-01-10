{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "3.8.1";
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    rev = "refs/tags/${version}";
    hash = "sha256-xepMbxglBpHL7mnJYlnvNUgixrFwf/Tc6b1zL4Wy+to=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_multiprocessing" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    changelog = "https://github.com/django/asgiref/blob/${src.rev}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
