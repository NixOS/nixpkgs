{
  lib,
  isPy3k,
  buildPythonPackage,
  fetchPypi,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "python3-openid";
  version = "3.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bxf9a3ny1js422j962zfzl4a9dhj192pvai05whn7j0iy9gdyrk";
  };

  propagatedBuildInputs = [ defusedxml ];

  doCheck = false;

  disabled = !isPy3k;

  meta = with lib; {
    description = "OpenID support for modern servers and consumers";
    homepage = "https://github.com/necaris/python3-openid";
    license = licenses.asl20;
  };
}
