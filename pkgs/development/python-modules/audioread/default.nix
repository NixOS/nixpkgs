{ lib
, buildPythonPackage
, fetchPypi
, pytestrunner
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "2.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "073904fabc842881e07bd3e4a5776623535562f70b1655b635d22886168dd168";
  };

  nativeBuildInputs = [ pytestrunner ];

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}
