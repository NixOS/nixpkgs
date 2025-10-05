{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasyncore,
}:

buildPythonPackage rec {
  pname = "pysecretsocks";
  version = "0.9.1-unstable-2023-11-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BC-SECURITY";
    repo = "PySecretSOCKS";
    rev = "da5be0e48f82097044894247343cef2111f13c7a";
    hash = "sha256-3jvMVsoKgBN4eRc6hyj7X/uu7NoJvofsbljVcgGfcPc=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyasyncore ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "secretsocks" ];

  meta = {
    description = "Socks server for tunneling a connection over another channel";
    homepage = "https://github.com/BC-SECURITY/PySecretSOCKS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
