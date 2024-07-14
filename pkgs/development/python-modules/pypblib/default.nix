{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pypblib";
  version = "0.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cd2TC/F3yjjW7rRzcC0F3wfhHyA4LbDHZkZSl+r0kGI=";
  };

  pythonImportsCheck = [ "pypblib" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pypblib/";
    description = "PBLib Python3 Bindings";
    license = licenses.mit;
    maintainers = [ maintainers.marius851000 ];
  };
}
