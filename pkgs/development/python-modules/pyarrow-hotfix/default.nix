{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyarrow-hotfix";
  version = "0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pitrou";
    repo = "pyarrow-hotfix";
    rev = "refs/tags/v${version}";
    hash = "sha256-LlSbxIxvouzvlP6PB8J8fJaxWoRbxz4wTs7Gb5LbM4A=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "pyarrow_hotfix" ];

  meta = with lib; {
    description = "Hotfix for the PyArrow security vulnerability CVE-2023-47248";
    homepage = "https://github.com/pitrou/pyarrow-hotfix";
    changelog = "https://github.com/pitrou/pyarrow-hotfix/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
