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
  version = "2.9.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LFGxTN2aaAKDFaKw6IUl03YJZziPmfqlfeiQK0VGW+Y=";
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
