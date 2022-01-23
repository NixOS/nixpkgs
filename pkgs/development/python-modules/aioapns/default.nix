{ buildPythonPackage
, fetchPypi
, h2
, lib
, pyjwt
, pyopenssl
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ce526910bc2514a84b8105abe80508526ceafc0097c89f86bbbc501f8666c99";
  };

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "An efficient APNs Client Library for Python/asyncio";
    homepage = "https://github.com/Fatal1ty/aioapns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
