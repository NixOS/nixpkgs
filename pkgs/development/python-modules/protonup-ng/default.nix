{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests, configparser }:

buildPythonPackage rec {
  pname = "protonup-ng";
  version = "0.2.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rys9Noa3+w4phttfcI1OGEDfHMy8s80bm8kM8TzssQA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "argparse" ""
  '';

  propagatedBuildInputs = [ requests configparser ];

  doCheck = false; # protonup does not have any tests
  pythonImportsCheck = [ "protonup" ];

  meta = with lib; {
    homepage = "https://github.com/cloudishBenne/protonup-ng";
    description = "CLI program and API to automate the installation and update of GloriousEggroll's Proton-GE";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Madouura cafkafk ];
    mainProgram = "protonup";
  };
}
