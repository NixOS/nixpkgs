{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pythonAtLeast,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "j2cli";
  version = "0.3.10";
  format = "setuptools";
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b29kOz+lwPcvvp8H4kb44TgFK59onhTHxk1YLFlwmuQ=";
  };

  doCheck = false; # tests aren't installed thus aren't found, so skip
  propagatedBuildInputs = [
    jinja2
    pyyaml
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/kolypto/j2cli";
    description = "Jinja2 Command-Line Tool";
    mainProgram = "j2";
    license = licenses.bsd2;
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
    maintainers = with maintainers; [
      rushmorem
      SuperSandro2000
    ];
  };
}
