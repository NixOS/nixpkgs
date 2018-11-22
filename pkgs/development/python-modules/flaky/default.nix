{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x9ixika7wqjj52x8wnsh1vk7jadkdqpx01plj7mlh8slwyq4s41";
  };

  buildInputs = [ mock pytest ];

  # waiting for feedback https://github.com/box/flaky/issues/97
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/box/flaky;
    description = "Plugin for nose or py.test that automatically reruns flaky tests";
    license = licenses.asl20;
  };

}
