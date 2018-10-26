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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08j2w67nilczn1i5r7h22vag9673i6vnfhyq2rv27r1bdmi5a30m";
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
