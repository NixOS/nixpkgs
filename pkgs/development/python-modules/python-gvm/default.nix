{ lib
, stdenv
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, lxml
, paramiko
, poetry-core
, pontos
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-gvm";
  version = "23.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jdfrmFpWOuQgYwV2NrRyRDwAZThWdBFgfLByVIZ5HhQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    defusedxml
    lxml
    paramiko
    pontos
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # No running SSH available
    "test_connect_error"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_feed_xml_error"
  ];

  pythonImportsCheck = [
    "gvm"
  ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/python-gvm";
    changelog = "https://github.com/greenbone/python-gvm/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
