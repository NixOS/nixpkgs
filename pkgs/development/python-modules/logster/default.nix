{ lib, buildPythonPackage, fetchFromGitHub, pygtail }:

buildPythonPackage rec {
  pname = "logster";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "etsy";
    repo = pname;
    rev = version;
    sha256 = "06ac5hydas24h2cn8l5i69v1z0min5hwh6a1lcm1b08xnvpsi85q";
  };

  propagatedBuildInputs = [ pygtail ];

  meta = with lib; {
    description = "Parses log files, generates metrics for Graphite and Ganglia";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/etsy/logster";
  };
}
