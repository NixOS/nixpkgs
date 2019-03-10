{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12bd5e41f372b2190e8d754b6e5829c2f11dbc764e10b30f57e59f829c9ca1da";
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
