{ buildPythonPackage
, fetchPypi
, h2
, lib
, pyjwt
, pyopenssl
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea58ce685aa6d0ffbdc3be4a6999c7268b9c765f806d3e4da7677c098fb72cbc";
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
