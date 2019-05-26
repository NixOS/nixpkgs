{ stdenv, isPy3k, buildPythonPackage, fetchPypi, defusedxml }:

buildPythonPackage rec {
  pname = "python3-openid";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00l5hrjh19740w00b3fnsqldnla41wbr2rics09dl4kyd1fkd3b2";
  };

  propagatedBuildInputs = [ defusedxml ];

  doCheck = false;

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    description = "OpenID support for modern servers and consumers";
    homepage = https://github.com/necaris/python3-openid;
    license = licenses.asl20;
  };
}
