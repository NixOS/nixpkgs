{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pkce";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RomeoDespres";
    repo = "pkce";
    rev = finalAttrs.version;
    hash = "sha256-dOHCu0pDXk9LM4Yobaz8GAfVpBd8rXlty+Wfhx+WPME=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkce" ];

  meta = {
    description = "Python module to work with PKCE";
    homepage = "https://github.com/RomeoDespres/pkce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
