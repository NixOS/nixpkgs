{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pykira";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zxglzmd2k1nc4wri76ykra910fdgli027nw9d6541ic7xmw87vj";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pykira" ];

  meta = with lib; {
    description = "Python module to interact with Kira modules";
    homepage = "https://github.com/stu-gott/pykira";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
