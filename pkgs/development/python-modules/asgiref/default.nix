{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "2.1.0";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "2bfd70fcc51df4036768b91d7b13524090dc8f366d79fa44ba2b0aeb47306344";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
