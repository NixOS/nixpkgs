{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
  version = "0.3.2";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
    sha256 = "0sp6yrz8dnwnl89ip3fm2qlflpr7q2adpfhi8jd2pc9gaixzx6hd";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Checks needs internet access
  doCheck = false;

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = https://github.com/romis2012/aiohttp-socks;
  };
}
