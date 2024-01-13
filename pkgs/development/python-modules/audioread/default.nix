{ lib
, buildPythonPackage
, fetchPypi
, flit-core
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rFRgpUmMSL3y6OdnQCWDpNzRP0QU0ob0LOQ3nos1Bm0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}
