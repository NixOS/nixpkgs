{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  psutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "command-runner";
  version = "1.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netinvent";
    repo = "command_runner";
    tag = "v${version}";
    hash = "sha256-jGYIz+c6wt137b8kG1QVVAvBAaJQAzNnZyKVeKHIk5c=";
  };

  build-system = [ setuptools ];

  dependencies = [ psutil ];

  # Tests are execute ping
  # ping: socket: Operation not permitted
  doCheck = false;

  pythonImportsCheck = [ "command_runner" ];

  meta = {
    homepage = "https://github.com/netinvent/command_runner";
    description = ''
      Platform agnostic command execution, timed background jobs with live
      stdout/stderr output capture, and UAC/sudo elevation
    '';
    changelog = "https://github.com/netinvent/command_runner/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
  };
}
