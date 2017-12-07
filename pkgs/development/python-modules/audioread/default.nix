{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  name = "${pname}-${version}";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffb601de7a9e40850d4ec3256a3a6bbe8fa40466dafb5c65f41b08e4bb963f1e";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}