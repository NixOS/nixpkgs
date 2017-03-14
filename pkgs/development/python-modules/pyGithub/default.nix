{ stdenv, fetchFromGitHub
, cacert
, buildPythonPackage, python-jose }:

buildPythonPackage rec {
  name = "PyGithub-${version}";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "15dr9ja63zdxax9lg6q2kcakqa82dpffyhgpjr13wq3sfkcy5pdw";
  };
  propagatedBuildInputs = [ python-jose ];
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt"; # necessary for test to succeed
  meta = {
    homepage = "https://github.com/PyGithub/PyGithub";
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jhhuh ];
  };
}
