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
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-gvm";
  version = "26.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "python-gvm";
    tag = "v${version}";
    hash = "sha256-9aqX6/Xb0E4+Ar95NwaCXxPTF0m9zLgzQSSacQqaPyc=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "defusedxml" ];

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_feed_xml_error" ];

  pythonImportsCheck = [ "gvm" ];

  meta = {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/python-gvm";
    changelog = "https://github.com/greenbone/python-gvm/releases/tag/${src.tag}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
