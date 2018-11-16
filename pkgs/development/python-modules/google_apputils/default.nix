{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, gflags
, dateutil
, mox
, python
}:

buildPythonPackage rec {
  pname = "google-apputils";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sxsm5q9vr44qzynj8l7p3l7ffb0zl1jdqhmmzmalkx941nbnj1b";
  };

  preConfigure = ''
    sed -i '/ez_setup/d' setup.py
  '';

  propagatedBuildInputs = [ pytz gflags dateutil mox ];

  checkPhase = ''
    ${python.executable} setup.py google_test
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Google Application Utilities for Python";
    homepage = http://code.google.com/p/google-apputils-python;
    license = licenses.asl20;
  };

}
