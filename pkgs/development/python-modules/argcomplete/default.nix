{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests-toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445";
  };

  doCheck = false; # meant to be ran with interactive interpreter

  # re-enable if we are able to make testing work
  # checkInputs = [ bashInteractive coverage flake8 ];

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
