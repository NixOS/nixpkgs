{ stdenv, lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "python-pushover";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dee1b1344fb8a5874365fc9f886d9cbc7775536629999be54dfa60177cf80810";
  };

  propagatedBuildInputs = [ requests ];

  # tests require network
  doCheck = false;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Bindings and command line utility for the Pushover notification service";
    homepage = "https://github.com/Thibauth/python-pushover";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
