{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09d762b9d83c65a83617ee57a3532eb10663f394c1caf81390516c5b1cc0fc6b";
  };

  # test data not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "puremagic" ];

  meta = with lib; {
    description = "Pure python implementation of magic file detection";
    license = licenses.mit;
    homepage = "https://github.com/cdgriffith/puremagic";
    maintainers = with maintainers; [ globin ];
  };
}
