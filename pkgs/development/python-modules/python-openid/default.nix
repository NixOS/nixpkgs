{ lib, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "python-openid";
  version = "2.2.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvhxlghjan01snfdc4k7ykd80vkyjgizwgg9bncnin8rqz1ricj";
  };

  # use python3-openid instead
  disabled = isPy3k;

  meta = {
    description = "OpenID support for servers and consumers";
    homepage = "https://github.com/openid/python-openid";
    license = lib.licenses.asl20;
  };
}
