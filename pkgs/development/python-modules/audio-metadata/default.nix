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
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e7ba79d49cf048a911d5f7d55bb2715c10be5c127fe5db0987c5fe1aa7335eb";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bidict>=0.17,<0.18" "bidict" \
      --replace "more-itertools>=4.0,<8.0" "more-itertools" \
      --replace "pendulum>=2.0,<=3.0,!=2.0.5,!=2.1.0" "pendulum>=2.0,<=3.0"
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
    homepage = "https://github.com/thebigmunch/audio-metadata";
    description = "A library for reading and, in the future, writing metadata from audio files";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
