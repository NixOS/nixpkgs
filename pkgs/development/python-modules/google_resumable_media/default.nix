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
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57841f5e65fb285c01071f439724745b2549a72eb75e5fd979198eb518608ed0";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ requests setuptools six ];

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
