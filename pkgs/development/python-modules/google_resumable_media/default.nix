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
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97155236971970382b738921f978a6f86a7b5a0b0311703d991e065d3cb55773";
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
