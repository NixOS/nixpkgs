{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, bidict
, bitstruct
, more-itertools
, pprintpp
}:

buildPythonPackage rec {
  pname = "audio-metadata";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jd0wzhh9as2qyiwggqmvsbsm5nlb73qnxix2mcar53cddvwrvj7";
  };

  propagatedBuildInputs = [
    attrs
    bidict
    bitstruct
    more-itertools
    pprintpp
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/audio-metadata;
    description = "A library for reading and, in the future, writing metadata from audio files";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
