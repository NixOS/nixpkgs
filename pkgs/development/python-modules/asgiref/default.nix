{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "1.1.1";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "0gayxnysknwg8hxb5kvmi2mmd5dnrhgza23daf8j25w3nj2drars";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
