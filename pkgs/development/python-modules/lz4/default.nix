{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, nose }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "lz4";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ghv1xbaq693kgww1x9c22bplz479ls9szjsaa4ig778ls834hm0";
  };

  buildInputs = [ setuptools_scm nose ];

  meta = with stdenv.lib; {
    description = "Compression library";
    homepage = https://github.com/python-lz4/python-lz4;
    license = licenses.bsd3;
  };
}
