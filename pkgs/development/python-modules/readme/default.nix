{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, docutils
, pygments
, bleach
, html5lib
}:

buildPythonPackage rec {
  pname = "readme";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32fbe1538a437da160fa4e4477270bfdcd8876e2e364d0d12898302644496231";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ six docutils pygments bleach html5lib ];

  checkPhase = ''
    py.test
  '';

  # Tests fail, possibly broken.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Readme is a library for rendering readme descriptions for Warehouse";
    homepage = "https://github.com/pypa/readme";
    license = licenses.asl20;
  };

}
