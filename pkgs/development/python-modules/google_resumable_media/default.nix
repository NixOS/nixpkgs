{ stdenv
, buildPythonPackage
, fetchPypi
, google_crc32c
, six
, requests
, setuptools
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpw5r83jvxqzmhr8bnl17ff4fjl2wknr752kx90lj71mmmwqfhp";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_crc32c requests setuptools six ];

  checkPhase = ''
    py.test tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = "https://github.com/GoogleCloudPlatform/google-resumable-media-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
