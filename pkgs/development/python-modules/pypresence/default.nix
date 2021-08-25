{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pypresence";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c8r7yxih5zp46qb9anq5s91pw2wr7d9d0nzcfh4l42x10c8lqal";
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
