{ lib
, buildPythonPackage
, dataclasses
, fetchPypi
, fetchpatch
, google-cloud-storage
, mock
, pytestCheckHook
, pythonOlder
, smart-open
, typer
}:

buildPythonPackage rec {
  pname = "pathy";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "838624441f799a06b446a657e4ecc9ebc3fdd05234397e044a7c87e8f6e76b1c";
  };

  propagatedBuildInputs = [
    smart-open
    typer
    google-cloud-storage
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  patches = [
    # Support for smart-open >= 6.0.0, https://github.com/justindujardin/pathy/pull/71
    (fetchpatch {
      name = "support-later-smart-open.patch";
      url = "https://github.com/justindujardin/pathy/commit/ba1c23df6ee5d1e57bdfe845ff6a9315cba3df6a.patch";
      sha256 = "sha256-V1i4tx73Xkdqb/wZhQIv4p6FVpF9SEfDhlBkwaaRE3w=";
    })
  ];

  disabledTestPaths = [
    # Exclude tests that require provider credentials
    "pathy/_tests/test_clients.py"
    "pathy/_tests/test_gcs.py"
    "pathy/_tests/test_s3.py"
  ];

  pythonImportsCheck = [
    "pathy"
  ];

  meta = with lib; {
    description = "A Path interface for local and cloud bucket storage";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
