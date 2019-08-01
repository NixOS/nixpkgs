{ buildPythonPackage, fetchPypi, lib,
  dicttoxml, pexpect, prettytable, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hdysr9z28sgwv47mivf4iyr1sg19hgfz349dghgdlk3rkl6v0s5";
  };

  doCheck = false; # bash-completion test fails with "compgen: command not found".

  # re-enable if we are able to make testing work
  # buildInputs = [ coverage flake8 ];

  propagatedBuildInputs = [ dicttoxml pexpect prettytable requests_toolbelt ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = https://argcomplete.readthedocs.io;
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
