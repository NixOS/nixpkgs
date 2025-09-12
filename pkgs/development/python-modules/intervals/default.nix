{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  infinity,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "intervals";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kvesteri";
    repo = "intervals";
    tag = version;
    hash = "sha256-5SwbGF7RU+2wgGnqhhFCdV89tsEIum4w7RwPU7+3MRQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ infinity ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "intervals" ];

  meta = {
    description = "Tools for handling intervals (ranges of comparable objects)";
    homepage = "https://github.com/kvesteri/intervals";
    changelog = "https://github.com/kvesteri/intervals/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
