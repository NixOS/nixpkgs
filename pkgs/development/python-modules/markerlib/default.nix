{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, nose
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "markerlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fdb3939441f5bf4f090b1979a34f84a11d33eed6c0e3995de88ae5c06b6e3ae";
  };

  buildInputs = [ setuptools ];
  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/dholth/markerlib/;
    description = "A compiler for PEP 345 environment markers";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
