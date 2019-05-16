{ stdenv
, buildPythonPackage
, fetchPypi
, six
, requests
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e38923493ca0d7de0ad91c31acfefc393c78586db89364e91cb4f11990e51ba";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ six requests ];

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
