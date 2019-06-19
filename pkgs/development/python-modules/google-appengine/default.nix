{ stdenv
, fetchPypi
, buildPythonPackage
, ez_setup, setuptools
}:
buildPythonPackage rec {

  pname = "google-appengine";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4e8205d0e00036b36db67e2ade44f155aa31eaba0f8fefdccccb528bfbc0b00";
  };

  doCheck = false;
  propagatedBuildInputs = [
    ez_setup
    setuptools
  ];

  meta = with stdenv.lib; {
    homepage = "http://pypi.org/project/google-appengine";
    license = licenses.bsdOriginal;
    description = "Google's AppEngine SDK to be run outside of virtualenv.";
    maintainer = with maintainers; [ BadDecisionsAlex ];
  };

}
