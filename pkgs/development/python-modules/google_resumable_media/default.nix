{ stdenv
, buildPythonPackage
, fetchPypi
, six
, requests
, setuptools
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a8fd188afe1cbfd5998bf20602f76b0336aa892de88fe842a806b9a3ed78d2a";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ requests setuptools six ];

  checkPhase = ''
    py.test tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = https://github.com/GoogleCloudPlatform/google-resumable-media-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
