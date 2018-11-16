{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, colored
, boto
, pkgs
}:

buildPythonPackage rec {
  pname = "lsi";
  version = "0.2.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0429iilb06yhsmvj3xp6wyhfh1rp4ndxlhwrm80r97z0w7plrk94";
  };

  propagatedBuildInputs = [ colored boto pkgs.openssh pkgs.which ];

  meta = with stdenv.lib; {
    description = "CLI for querying and SSHing onto AWS EC2 instances";
    homepage = https://github.com/NarrativeScience/lsi;
    maintainers = [maintainers.adnelson];
    license = licenses.mit;
  };

}
