{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fqdn";
  version = "1.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ypcrts";
    repo = "fqdn";
    rev = "v${version}";
    hash = "sha256-T0CdWWr8p3JVhp3nol5hyxsrD3951JE2EDpFt+m+3bE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fqdn" ];

  meta = with lib; {
    description = "RFC-compliant FQDN validation and manipulation";
    homepage = "https://github.com/ypcrts/fqdn";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}
