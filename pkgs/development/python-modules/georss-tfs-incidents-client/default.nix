{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "georss-tfs-incidents-client";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-tfs-incidents-client";
    rev = "v${version}";
    hash = "sha256-Cz0PRcGReAE0mg04ktCUaoLqPTjvyU1TiB/Pdz7o7zo=";
  };

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_tfs_incidents_client" ];

  meta = {
    description = "Python library for accessing Tasmania Fire Service Incidents feed";
    homepage = "https://github.com/exxamalte/python-georss-tfs-incidents-client";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
