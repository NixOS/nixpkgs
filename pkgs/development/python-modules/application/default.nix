{ lib, buildPythonPackage, fetchFromGitHub, zope_interface, isPy3k }:

buildPythonPackage rec {
  pname = "python-application";
  version = "2.8.0";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1xd2gbpmx2ghap9cnr1h6sxjai9419bdp3y9qp5lh67977m0qg30";
  };

  buildInputs = [ zope_interface ];

  # No tests upstream to run
  doCheck = false;

  meta = with lib; {
    description = "Basic building blocks for python applications";
    homepage = "https://github.com/AGProjects/python-application";
    changelog = "https://github.com/AGProjects/python-application/blob/master/ChangeLog";
    license = licenses.lgpl2Plus;
  };
}
