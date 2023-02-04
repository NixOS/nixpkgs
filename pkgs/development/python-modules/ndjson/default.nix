{ lib, buildPythonPackage, fetchPypi, watchdog, flake8
, pytest, pytest-runner, coverage, sphinx, twine }:

buildPythonPackage rec {
  pname = "ndjson";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "v5dGy2uxy1PRcs2n8VTAfHhtZl/yg0Hk5om3lrIp5dY=";
  };

  nativeCheckInputs = [ pytest pytest-runner flake8 twine sphinx coverage watchdog ];

  meta = with lib; {
    homepage = "https://github.com/rhgrant10/ndjson";
    description = "JsonDecoder";
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ freezeboy ];
  };
}
