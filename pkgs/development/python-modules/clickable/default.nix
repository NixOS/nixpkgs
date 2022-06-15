{ lib
, buildPythonPackage
, fetchPypi
, requests
, cookiecutter
, argcomplete
, pyyaml
, jsonschema }:

buildPythonPackage rec {
  pname = "clickable";
  version = "7.4.0";

  src = fetchPypi {
    pname = "clickable-ut";
    inherit version;
    sha256 = "sha256-xdRYPOsNX75pSh/IhClIpQ6zfijsKEY3FC5S5tZvEmY=";
  };

  propagatedBuildInputs = [
    requests
    cookiecutter
    argcomplete
    pyyaml
    jsonschema
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://clickable-ut.dev/en/latest/";
    description = "Compile, build, and deploy Ubuntu Touch click packages all from the command line";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };
}
