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
    hash = "sha256-M/v2ko9AHgt5AVHtK1KQsCVF6HdfmCSFIFoGb4dKrq8=";
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
