{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-dependency";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RKrahl";
    repo = "pytest-dependency";
    tag = version;
    hash = "sha256-1tAikpdCLJMmylIbd1zQ45Bq+95O5cDQxNGwe3XpZuw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "UNKNOWN" "${version}"
  '';

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_dependency" ];

  meta = {
    homepage = "https://github.com/RKrahl/pytest-dependency";
    changelog = "https://github.com/RKrahl/pytest-dependency/blob/${version}/CHANGES.rst";
    description = "Manage dependencies of tests";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
