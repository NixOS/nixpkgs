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
  version = "3.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-25Rytq5PupaLQJ3DL67iDdZQiQZdqpPgjSG3lqZdZXg=";
  };

  propagatedBuildInputs = [
    requests
    requests-toolbelt
  ];

  passthru.optional-dependencies = {
    autocompletion = [
      argcomplete
    ];
    yaml = [
      pyyaml
    ];
  };

  # Tests rely on a gitlab instance on a local docker setup
  doCheck = false;

  pythonImportsCheck = [
    "gitlab"
  ];

  meta = with lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
