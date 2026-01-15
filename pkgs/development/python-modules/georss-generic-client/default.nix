{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "georss-generic-client";
  version = "0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-generic-client";
    rev = "v${version}";
    hash = "sha256-Y19zMHL6DjAqiDi47Lmst8m9d9kEtTgyRiECKo6CqZY=";
  };

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_generic_client" ];

  meta = {
    description = "Python library for accessing generic GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-generic-client";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
