{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
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

  meta = with lib; {
    description = "The Datadog Python library";
    license = licenses.bsd3;
    homepage = https://github.com/DataDog/datadogpy;
  };
}
