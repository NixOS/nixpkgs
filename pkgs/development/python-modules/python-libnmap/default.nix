{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "python-libnmap";
  version = "0.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "savon-noir";
    repo = "python-libnmap";
    tag = "v${version}";
    hash = "sha256-cI8wdOvTmRy2cxLBkJn7vXRBRvewDMNl/tkIiRGhZJ8=";
  };

  optional-dependencies = {
    defusedxml = [ defusedxml ];
  };

  # We don't want the nmap binary being present
  doCheck = false;

  pythonImportsCheck = [ "libnmap" ];

  meta = {
    description = "Library to run nmap scans, parse and diff scan results";
    homepage = "https://github.com/savon-noir/python-libnmap";
    changelog = "https://github.com/savon-noir/python-libnmap/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
