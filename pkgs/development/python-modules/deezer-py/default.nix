{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "1.2.7";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20a99337fc22b7406f5bb9b4687535b91a61dc31998c0369c4efc76dffeb9a2c";
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
