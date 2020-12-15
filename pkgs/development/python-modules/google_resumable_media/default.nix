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
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee98b1921e5bda94867a08c864e55b4763d63887664f49ee1c231988f56b9d43";
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
