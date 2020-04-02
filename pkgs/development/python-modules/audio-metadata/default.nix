{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, bidict
, bitstruct
, more-itertools
, pprintpp
, tbm-utils
}:

buildPythonPackage rec {
  pname = "audio-metadata";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v7ww3csyxrhnpvpynla64hfn1wp37vbw7srh9343n4wc02mh65l";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bidict>=0.17,<0.18" "bidict" \
      --replace "more-itertools>=4.0,<8.0" "more-itertools"
  '';

  propagatedBuildInputs = [
    attrs
    bidict
    bitstruct
    more-itertools
    pprintpp
    tbm-utils
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
