{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "2.1.5";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "1a46196df28c67e046a54cc537ce5a8f6a59eb68649f54680d7e4fc3b113ab1b";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
