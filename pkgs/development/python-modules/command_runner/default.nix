{ lib, buildPythonPackage, fetchPypi, psutil }:

buildPythonPackage rec {
  pname = "command_runner";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lzt1UhhrPqQrBKsRmPhqhtOIfFlCteQqo6sZ6rOut0A=";
  };

  propagatedBuildInputs = [ psutil ];

  meta = with lib; {
    homepage = "https://github.com/netinvent/command_runner";
    description = ''
      Platform agnostic command execution, timed background jobs with live
      stdout/stderr output capture, and UAC/sudo elevation
    '';
    license = licenses.bsd3;
    maintainers = teams.wdz.members;
  };
}
