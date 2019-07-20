{ stdenv, buildPythonPackage, fetchPypi
, unittest2, lxml, robotframework
}:

buildPythonPackage rec {
  pname = "robotsuite";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15iw7g6gspf1ill0mzjrj71dirqfc86f1j14wphdvs2lazv8d50z";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ robotframework lxml ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace robotframework-python3 robotframework
  '';

  meta = with stdenv.lib; {
    description = "Python unittest test suite for Robot Framework";
    homepage = https://github.com/collective/robotsuite/;
    license = licenses.gpl3;
  };
}
