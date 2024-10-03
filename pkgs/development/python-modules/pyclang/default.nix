{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyclang";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "clang-tidy-runner";
    rev = "v${version}";
    hash = "sha256-UiSKt8p6VuviKzP1xq9oqtxVlyz9Dhj/HcqLYmklmjo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyclang" ];

  meta = {
    description = "Clang Tidy Runner";
    homepage = "https://github.com/espressif/clang-tidy-runner";
    changelog = "https://github.com/espressif/clang-tidy-runner/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
