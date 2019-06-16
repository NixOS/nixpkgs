{ buildPythonPackage
, lib
, fetchPypi
, msrest
}:

buildPythonPackage rec {
  version = "5.0.0b8";
  pname = "azure-devops";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hssbmg53zkixnr5hj52arwyq2k06jygxm49py88nnlbkkhxhxaf";
  };

  propagatedBuildInputs = [ msrest ];

  # Tests are highly impure
  checkPhase = ''
    python -c 'import azure.devops.version; print(azure.devops.version.VERSION)'
  '';

  meta = with lib; {
    description = "Python APIs for interacting with and managing Azure DevOps";
    homepage = https://github.com/microsoft/azure-devops-python-api;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
