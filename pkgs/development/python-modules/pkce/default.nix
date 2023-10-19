{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pkce";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "RomeoDespres";
    repo = pname;
    rev = version;
    hash = "sha256-dOHCu0pDXk9LM4Yobaz8GAfVpBd8rXlty+Wfhx+WPME=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkce" ];

  meta = with lib; {
    description = "Python module to work with PKCE";
    homepage = "https://github.com/RomeoDespres/pkce";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
