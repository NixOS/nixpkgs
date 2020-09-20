{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, six
, requests
, setuptools
, pytest
, mock
, crcmod
, google-crc32c
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "FzrMa63hSApSn6KcbCcXVDri3AnULpRh/bhvOVAu/PI=";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ requests setuptools six ]
    ++ lib.optional isPy3k google-crc32c
    ++ lib.optional (!isPy3k) crcmod;

  checkPhase = ''
    py.test tests/unit
  '';

  meta = with lib; {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = "https://github.com/GoogleCloudPlatform/google-resumable-media-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
