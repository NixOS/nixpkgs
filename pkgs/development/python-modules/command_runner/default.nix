{ lib, buildPythonPackage, fetchPypi, psutil }:

buildPythonPackage rec {
  pname = "command_runner";
  version = "1.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jzTckxDQxY8nIvQE3l0RTfpOH8RVIylS3YN3izr7Ns8=";
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
