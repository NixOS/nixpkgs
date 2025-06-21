{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "autoray";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchPypi {
    inherit version;
    pname = "autoray";
    sha256 = "sha256-5a9sYrp8O+ijayqxnjRMcV80eNOaDkd1Wq02VXK8kPg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  doCheck = true;

  pythonImportsCheck = [ "autoray" ];

  meta = {
    homepage = "https://github.com/jcmgray/autoray";
    description = "Abstract your array operations";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
