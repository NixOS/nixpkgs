{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "2.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3480e42056c8e80a8192a54f6729a280ef66d27782ee11cbd63e9d4d1523089";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}
