{ buildPythonPackage, fetchPypi, lib
, dicttoxml
, importlib-metadata
, pexpect
, prettytable
, requests_toolbelt
}:
buildPythonPackage rec {
  pname = "argcomplete";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h1przxffrhqvi46k40pzjsvdrq4zc3sl1pc96kkigqppq0vdrss";
  };

  doCheck = false; # meant to be ran with interactive interpreter

  # re-enable if we are able to make testing work
  # checkInputs = [ bashInteractive coverage flake8 ];

  propagatedBuildInputs = [
    dicttoxml
    importlib-metadata
    pexpect
    prettytable
    requests_toolbelt
  ];

  pythonImportsCheck = [ "argcomplete" ];

  meta = with lib; {
    description = "Bash tab completion for argparse";
    homepage = "https://kislyuk.github.io/argcomplete/";
    maintainers = [ maintainers.womfoo ];
    license = [ licenses.asl20 ];
  };
}
