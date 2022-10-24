{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  markdown-it-py,
  coverage,
  mdformat,
  pytest,
  pytest-cov,
}:
buildPythonPackage rec {
  pname = "mdformat-tables";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q61GmaRxjxJh9GjyR8QCZOH0njFUtAWihZ9lFQJ2nQQ=";
  };

  buildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    markdown-it-py
    mdformat
  ];

  checkInputs = [
    coverage
    pytest
    pytest-cov
  ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "An mdformat plugin for rendering tables";
    homepage = "https://github.com/executablebooks/mdformat-tables";
    license = with licenses; [mit];
    maintainers = with maintainers; [djacu];
  };
}
