{
  lib,
  buildPythonPackage,
  fetchPypi,
  blessings,
  colorama,
  glob2,
}:

buildPythonPackage rec {
  pname = "ronin";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-5gZ8S0NR4JzKBIdi/xYtVmFg9ObbCSkT7sz+OKWnK/U=";
  };

  propagatedBuildInputs = [
    blessings
    colorama
    glob2
  ];

  pythonImportsCheck = [ "ronin" ];

  meta = with lib; {
    homepage = "https://github.com/tliron/ronin/";
    description = "Straightforward but powerful build system based on Ninja and Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
