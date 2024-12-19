{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lazr-delegates,
  zope-interface,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazr-config";
  version = "3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr.config";
    inherit version;
    hash = "sha256-oU5PbMCa68HUCxdhWK6g7uIlLBQAO40O8LMcfFFMNkQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    lazr-delegates
    zope-interface
  ];

  pythonImportsCheck = [ "lazr.config" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # change the directory to avoid a namespace-related problem
  # ModuleNotFoundError: No module named 'lazr.delegates'
  preCheck = ''
    cd $out
  '';

  pythonNamespaces = [ "lazr" ];

  meta = with lib; {
    description = "Create configuration schemas, and process and validate configurations";
    homepage = "https://launchpad.net/lazr.config";
    changelog = "https://git.launchpad.net/lazr.config/tree/NEWS.rst?h=${version}";
    license = licenses.lgpl3Only;
  };
}
