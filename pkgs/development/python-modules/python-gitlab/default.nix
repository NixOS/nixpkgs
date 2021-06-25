{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, argcomplete
, requests
, requests-toolbelt
, pyyaml
}:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0081jgjgqi4mqpr436ivw2q571hxi3hv2pa8d0z0nfl13s6lldpk";
  };

  propagatedBuildInputs = [
    argcomplete
    pyyaml
    requests
    requests-toolbelt
  ];

  # tests rely on a gitlab instance on a local docker setup
  doCheck = false;

  pythonImportsCheck = [
    "gitlab"
  ];

  meta = with lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
