{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylgnetcast";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "python-lgnetcast";
    rev = "v${version}-1";
    sha256 = "04bh5i4zchdg0lgwpic8wfbk77n225g71z55iin9r0083xbhd7bh";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylgnetcast"
  ];

  meta = with lib; {
    description = "Python API client for the LG Smart TV running NetCast 3 or 4";
    homepage = "https://github.com/Drafteed/python-lgnetcast";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
