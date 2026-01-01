{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fqdn";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ypcrts";
    repo = "fqdn";
    rev = "v${version}";
    hash = "sha256-T0CdWWr8p3JVhp3nol5hyxsrD3951JE2EDpFt+m+3bE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fqdn" ];

<<<<<<< HEAD
  meta = {
    description = "RFC-compliant FQDN validation and manipulation";
    homepage = "https://github.com/ypcrts/fqdn";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "RFC-compliant FQDN validation and manipulation";
    homepage = "https://github.com/ypcrts/fqdn";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
