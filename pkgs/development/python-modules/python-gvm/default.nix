{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, pythonOlder
, paramiko
, lxml
, defusedxml
}:

buildPythonPackage rec {
  pname = "python-gvm";
  version = "21.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "070qpj2y7834i50lhkkbv93s77j91js06zs1bpbmplppiraxqmyz";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    paramiko
    lxml
    defusedxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/greenbone/python-gvm/pull/552
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/greenbone/python-gvm/commit/e48afa614ba9cf69d9b22ce1a4642c625acbaa06.patch";
      sha256 = "0f5wfdymp5dcjk1xb7ynsf0g6idjg2ifwgggp4agic5nkh1k1inl";
    })
  ];

  disabledTests = [
    # No running SSH available
    "test_connect_error"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_feed_xml_error"
  ];

  pythonImportsCheck = [ "gvm" ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/python-gvm";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
