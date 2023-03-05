{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests-toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HP0Sko1i5BkBeD5Nx9fKA+zNWJhA+s5MAgaTsT91QxI=";
  };

  doCheck = false; # meant to be ran with interactive interpreter

  # re-enable if we are able to make testing work
  # nativeCheckInputs = [ bashInteractive coverage flake8 ];

  propagatedBuildInputs = [
    dicttoxml
    importlib-metadata
    pexpect
    prettytable
    requests-toolbelt
  ];

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
