{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "1.1.2";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "8b46c3d6e2ad354d9da3cfb9873f9bd46fe1b768fbc11065275ba5430a46700c";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
