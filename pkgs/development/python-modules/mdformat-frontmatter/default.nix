{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  mdformat,
  mdit-py-plugins,
  ruamel-yaml,
  coverage,
  pytest,
  pytest-cov,
}:
buildPythonPackage rec {
  pname = "mdformat-frontmatter";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "butler54";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gaaWPwtnlSPUv8ai2RJsAcwxCZaHtqPlkjAlauQrr78=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
  ];

  checkInputs = [
    coverage
    pytest
    pytest-cov
  ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "An mdformat plugin for ensuring that yaml front-matter is respected";
    homepage = "https://github.com/butler54/mdformat-frontmatter";
    license = with licenses; [mit];
    maintainers = with maintainers; [djacu];
  };
}
