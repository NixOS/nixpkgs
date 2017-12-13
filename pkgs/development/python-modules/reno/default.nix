{ lib, fetchPypi, buildPythonPackage
, pbr
, six
, pyyaml
, dulwich
, Babel
, testtools
, testscenarios
, testrepository
, gnupg
, git
}:

buildPythonPackage rec {
  pname = "reno";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cq6msiqx4g8azlwk8v6n0vvbngbqvjzskrq36dqkvcvaxaqc3py";
  };

  # Don't know how to make tests pass
  ## dulwich.errors.NotGitRepository: No git repository was found at ./
  doCheck = false;
  checkInputs = [ testtools testscenarios testrepository gnupg git ];

  propagatedBuildInputs = [ pbr six pyyaml dulwich ];
  buildInputs = [ Babel ];

  meta = with lib; {
    description = "Release Notes Manager";
    homepage    = http://docs.openstack.org/developer/reno/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ guillaumekoenig ];
  };
}
