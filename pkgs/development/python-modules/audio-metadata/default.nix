{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, bidict
, bitstruct
, more-itertools
, pprintpp
}:

buildPythonPackage rec {
  pname = "audio-metadata";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a881f0f3b82752d306ac0a7850ed0e31bad275a399f63097733b4890986084b2";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bidict>=0.17,<0.18" "bidict" \
      --replace "more-itertools>=4.0,<5.0" "more-itertools"
  '';

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
