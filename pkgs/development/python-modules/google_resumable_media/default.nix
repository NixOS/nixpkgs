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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pvp0napkf0hnnf2aj4bmmcsrmphy8x608qhjbdnb9ji6nxqzsyd";
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
