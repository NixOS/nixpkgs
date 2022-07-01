{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pypresence";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "691daf98c8189fd216d988ebfc67779e0f664211512d9843f37ab0d51d4de066";
  };

  doCheck = false; # tests require internet connection
  pythonImportsCheck = [ "pypresence" ];

  meta = with lib; {
    homepage = "https://qwertyquerty.github.io/pypresence/html/index.html";
    description = "Discord RPC client written in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
  };
}
