{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ad7880aef8c35a34ddb394d4fa33047765bca1e3d67d182bf6eba9c8eabf3a2";
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
