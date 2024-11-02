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
    sha256 = "0qlhykm9flj6cv3v0b9q40gy21yz0lnp0wxlxvb3ijkpy45r7pbi";
  };

  pythonImportsCheck = [ "pypblib" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/pypblib/";
    description = "PBLib Python3 Bindings";
    license = licenses.mit;
    maintainers = [ maintainers.marius851000 ];
  };
}
