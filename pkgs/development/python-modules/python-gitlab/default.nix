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
  version = "3.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rVArcrXRE39K831KaK4g/n1sl3j2fL4q7FZveZUFPH0=";
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
    changelog = "https://github.com/python-gitlab/python-gitlab/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
