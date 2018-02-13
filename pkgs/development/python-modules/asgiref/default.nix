{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "2.1.1";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "112828022d772925b47b22caf8108dadd3b26bb0af719eb01b2c3a807795429d";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
