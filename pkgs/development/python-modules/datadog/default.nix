{ lib, buildPythonPackage, fetchPypi
, decorator, requests, simplejson
, nose, mock }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ed9aec2b3a26722b74465c2ed36d2efdb9c9fac1a07a84d81fa2fc0cfa66ae4";
  };

  propagatedBuildInputs = [ decorator requests simplejson ];

  checkInputs = [ nose mock ];

  # v0.20.0 tests are nondeterministic:
  # test_send_batch_metrics: https://hydra.nixos.org/build/74920933
  # test_timed_decorator_threaded: https://hydra.nixos.org/build/74328993
  doCheck = false;

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
