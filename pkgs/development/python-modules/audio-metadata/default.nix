{ lib, buildPythonPackage, fetchPypi
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
      --replace "'attrs>=18.2,<19.4'" "'attrs'"
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

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/audio-metadata";
    description = "A library for reading and, in the future, writing metadata from audio files";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
