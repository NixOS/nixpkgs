{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "georss-wa-dfes-client";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-wa-dfes-client";
    rev = "v${version}";
    hash = "sha256-s7qGTlWFdOtw0eMK7idld7HPOxO8CjODCmUi0WmRLdI=";
  };

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_wa_dfes_client" ];

  meta = with lib; {
    description = "Python library for accessing WA Department of Fire and Emergency Services (DFES) feed";
    homepage = "https://github.com/exxamalte/python-georss-wa-dfes-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
