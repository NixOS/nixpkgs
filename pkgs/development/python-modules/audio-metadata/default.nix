{ lib
, buildPythonPackage
, fetchPypi
, attrs
, bidict
, bitstruct
, more-itertools
, pprintpp
, tbm-utils
, pythonRelaxDepsHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "audio-metadata";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e7ba79d49cf048a911d5f7d55bb2715c10be5c127fe5db0987c5fe1aa7335eb";
  };

  pythonRelaxDeps = [
    "attrs"
    "more-itertools"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

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

  pythonImportsCheck = [
    "audio_metadata"
  ];

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/audio-metadata";
    description = "A library for reading and, in the future, writing metadata from audio files";
    changelog = "https://github.com/thebigmunch/audio-metadata/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
