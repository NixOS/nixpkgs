{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests, configparser }:

buildPythonPackage rec {
  pname = "protonup";
  version = "0.1.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z5q0s9h51w2bqm9lkafml14g13v2dgm4nm9x06v7nxqc9msmyyy";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "argparse" ""
  '';

  propagatedBuildInputs = [ requests configparser ];

  doCheck = false; # protonup does not have any tests
  pythonImportsCheck = [ "protonup" ];

  meta = with lib; {
    homepage = "https://github.com/AUNaseef/protonup";
    description = "CLI program and API to automate the installation and update of GloriousEggroll's Proton-GE";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flexagoon ];
  };
}
