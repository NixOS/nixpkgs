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
  version = "0.4.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2c4a9a276a32f914a6193509503c28b3cc84bf42d58e191214811cfe78f4736";
  };

  propagatedBuildInputs = [ colored boto pkgs.openssh pkgs.which ];

  meta = with stdenv.lib; {
    description = "CLI for querying and SSHing onto AWS EC2 instances";
    homepage = https://github.com/NarrativeScience/lsi;
    maintainers = [maintainers.adnelson];
    license = licenses.mit;
  };

}
