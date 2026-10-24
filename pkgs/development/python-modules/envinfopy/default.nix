{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "envinfopy";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "envinfopy";
    tag = "v${version}";
    hash = "sha256-0T73lnQOMOX6jPMUHvtpTt8eTmJqZn2rOQ6bNKG3eno=";
  };

  build-system = [ setuptools ];

  # envinfopy has no required runtime dependencies

  pythonImportsCheck = [ "envinfopy" ];

  meta = {
    description = "Python library to get basic environment information";
    homepage = "https://github.com/thombashi/envinfopy";
    changelog = "https://github.com/thombashi/envinfopy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
