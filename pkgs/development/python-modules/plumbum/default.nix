{ buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.6.9";

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ps37vamqav6p277dlp51jnacd5q4x4z1x8y0nfjw3y8jsfy3f8n";
  };
}