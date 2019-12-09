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
    sha256 = "0aldswz9lsw05a2gx26yjal6lcxhfqpn085zk1czvjz1my4d33ra";
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
