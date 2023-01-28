{ lib
, stdenv
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, lxml
, paramiko
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-gvm";
  version = "22.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-V9xfPYwDDoCGJPstzYsC/ikUp45uiaZE0Bg4i9tRNhU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    defusedxml
    lxml
    paramiko
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
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
