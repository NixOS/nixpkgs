{
  lib,
  stdenv,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  lxml,
  paramiko,
  poetry-core,
  pontos,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-gvm";
  version = "24.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "python-gvm";
    rev = "refs/tags/v${version}";
    hash = "sha256-GIEsP8+RJMIehsBbZWpIRXCdqxm042lPbYTHY7/fknM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    defusedxml
    lxml
    paramiko
    typing-extensions
  ];

  nativeCheckInputs = [
    pontos
    pytestCheckHook
  ];

  disabledTests = [
    # No running SSH available
    "test_connect_error"
    "test_feed_xml_error"
  ] ++ lib.optionals stdenv.isDarwin [ "test_feed_xml_error" ];

  pythonImportsCheck = [ "gvm" ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/python-gvm";
    changelog = "https://github.com/greenbone/python-gvm/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
