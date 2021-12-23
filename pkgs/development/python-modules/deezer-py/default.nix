{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "1.2.9";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16eacdc9c53f55d2130891c6335e88046afa0601184fd5197fee35a09e99d9cf";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "requests" ];

  meta = with lib; {
    homepage = "https://gitlab.com/RemixDev/deezer-py";
    description = "A wrapper for all Deezer's APIs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natto1784 ];
  };
}
