{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  babel,
  setuptools,
  wheel,
  pynpm,
}:

buildPythonPackage rec {
  pname = "pywebpack";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "pywebpack";
    rev = "v${version}";
    hash = "sha256-swIqm/TBmx4Mc/hC727TzP0xiFw1Tb3ATczpSKTgNqM=";
  };

  nativeBuildInputs = [
    babel
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ pynpm ];

  pythonImportsCheck = [ "pywebpack" ];

  meta = {
    description = "Webpack integration layer for Python";
    homepage = "https://github.com/inveniosoftware/pywebpack";
    changelog = "https://github.com/inveniosoftware/pywebpack/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thubrecht ];
  };
}
