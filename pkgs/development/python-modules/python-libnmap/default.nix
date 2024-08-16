{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-libnmap";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "savon-noir";
    repo = "python-libnmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-cI8wdOvTmRy2cxLBkJn7vXRBRvewDMNl/tkIiRGhZJ8=";
  };

  passthru.optional-dependencies = {
    defusedxml = [ defusedxml ];
  };

  # We don't want the nmap binary being present
  doCheck = false;

  pythonImportsCheck = [ "libnmap" ];

  meta = with lib; {
    description = "Library to run nmap scans, parse and diff scan results";
    homepage = "https://github.com/savon-noir/python-libnmap";
    changelog = "https://github.com/savon-noir/python-libnmap/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
