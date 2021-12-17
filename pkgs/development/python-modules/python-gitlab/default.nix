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
  version = "2.10.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7afa7d7c062fa62c173190452265a30feefb844428efc58ea5244f3b9fc0d40f";
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
