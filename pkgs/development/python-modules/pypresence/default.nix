{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pypresence";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-phkaOvM6lmfypO8BhVd8hrli7nCqgmQ8Rydopv7R+/M=";
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
