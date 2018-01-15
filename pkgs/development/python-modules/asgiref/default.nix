{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  version = "2.0.1";
  pname = "asgiref";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgiref/${name}.tar.gz";
    sha256 = "c3d70c473a2b7e525e18e68504630943e107f5b32f440c00c8543f94f565c855";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
