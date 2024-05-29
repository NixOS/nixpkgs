{
  lib,
  buildPythonPackage,
  dfdatetime,
  dtfabric,
  fetchPypi,
  libcreg-python,
  libregf-python,
  pyyaml,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "dfwinreg";
  version = "20240229";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-guiWjSx3LsPkPOgqN6axfE36FOuZet5LrnYIHZqQ6WM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dfdatetime
    libregf-python
    libcreg-python
    pyyaml
    dtfabric
  ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    changelog = "https://github.com/log2timeline/dfwinreg/releases/tag/${version}";
    description = "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects. The goal of dfWinReg is to provide a generic interface for accessing Windows Registry objects that resembles the Registry key hierarchy as seen on a live Windows system.";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    homepage = "https://github.com/log2timeline/dfwinreg";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
