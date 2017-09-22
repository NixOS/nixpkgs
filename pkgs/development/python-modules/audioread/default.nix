{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  name = "${pname}-${version}";
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36c3b118f097c58ba073b7d040c4319eff200756f094295677567e256282d0d7";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}