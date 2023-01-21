{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pastedeploy";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Pylons";
    repo = pname;
    rev = version;
    sha256 = "sha256-9/8aM/G/EdapCZJlx0ZPzNbmw2uYjA1zGbNWJAWoeCU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = "https://github.com/Pylons/pastedeploy";
    license = licenses.mit;
    maintainers = teams.openstack.members;
  };
}
