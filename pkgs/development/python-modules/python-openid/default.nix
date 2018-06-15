{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-openid";
  name = "${pname}-${version}";
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vvhxlghjan01snfdc4k7ykd80vkyjgizwgg9bncnin8rqz1ricj";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "OpenID support for modern servers and consumers";
    homepage = http://github.com/openid/python-openid;
    license = licenses.asl20;
  };
}
