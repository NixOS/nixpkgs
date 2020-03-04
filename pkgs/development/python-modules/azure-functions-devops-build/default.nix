{ lib, buildPythonPackage, fetchFromGitHub
, jinja2
, msrest
, vsts
}:

buildPythonPackage rec {
  version = "0.0.22";
  pname = "azure-functions-devops-build";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-functions-devops-build";
    # rev picked based on pypi release date
    rev = "c8249670acc77333e3de8b21dec60faf7ecf0951";
    sha256 = "1slc7jd92v9q1qg1yacnrpi2a7hi7iw61wzbzfd6wx9q63pw9yqi";
  };

  propagatedBuildInputs = [ jinja2 msrest vsts ];

  # circular dependency with azure-cli-core
  doCheck = false;

  meta = with lib; {
    description = "Integrate Azure Functions with Azure DevOps. Specifically made for the Azure CLI";
    homepage = "https://github.com/Azure/azure-functions-devops-build";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
