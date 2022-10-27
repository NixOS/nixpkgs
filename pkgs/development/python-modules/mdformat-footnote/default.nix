{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  mdformat,
  mdit-py-plugins,
  coverage,
  pytest,
  pytest-cov,
}:
buildPythonPackage rec {
  pname = "mdformat-footnote";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DUCBWcmB5i6/HkqxjlU3aTRO7i0n2sj+e/doKB8ffeo=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  checkInputs = [
    coverage
    pytest
    pytest-cov
  ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "A format addition for mdformat";
    homepage = "https://github.com/executablebooks/mdformat-footnote";
    license = with licenses; [mit];
    maintainers = with maintainers; [djacu];
  };
}
