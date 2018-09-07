{ lib, buildPythonPackage, fetchFromGitHub
, decorator, requests, simplejson
, nose, mock }:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.20.0";

  # no tests in PyPI tarball
  # https://github.com/DataDog/datadogpy/pull/259
  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "datadogpy";
    rev = "v${version}";
    sha256 = "1p4p14853yrsl8py4ca7za7a12qzw0xwgz64f5kzx8a6vpv3p3md";
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
