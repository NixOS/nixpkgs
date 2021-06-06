{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, plumbum
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    sha256 = "1g75k4valfjgab00xri4pf8c8bb2zxkhgkpyy44fjk7s5j66daa1";
  };

  propagatedBuildInputs = [ plumbum ];

  checkInputs = [ pytestCheckHook ];

  # Disable tests that requires network access
  disabledTests = [
    "test_api"
    "test_pruning"
    "test_rpyc"
  ];
  pythonImportsCheck = [ "rpyc" ];

  meta = with lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = "https://rpyc.readthedocs.org";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
