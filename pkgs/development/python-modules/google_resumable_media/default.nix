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
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49493999cf046b5a02f648e201f0c2fc718c5969c53326b4d2c0693b01bdc8bb";
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
