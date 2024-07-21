{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bumps";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MpUpj3/hsjkrsv+Ix6Cuadd6dpivWAqBVwBSygW6Uw8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bumps" ];

  meta = with lib; {
    description = "Data fitting with bayesian uncertainty analysis";
    mainProgram = "bumps";
    homepage = "https://bumps.readthedocs.io/";
    changelog = "https://github.com/bumps/bumps/releases/tag/v${version}";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rprospero ];
  };
}
