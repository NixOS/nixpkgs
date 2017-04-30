{ lib, fetchPypi, buildPythonPackage, defusedxml, isPy3k }:

buildPythonPackage rec {
  pname = "python3-openid";
  version = "3.1.0";
  name  = "${pname}-${version}";

  # use python-openid instead
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00l5hrjh19740w00b3fnsqldnla41wbr2rics09dl4kyd1fkd3b2";
  };

  propagatedBuildInputs = [ defusedxml ];

  # requires not-yet-packaged dependencies
  doCheck = false;

  meta = {
    description = "OpenID support for modern servers and consumers";
    homepage = "https://github.com/necaris/python3-openid";
    license = lib.licenses.asl20;
  };
}
