{
  lib,
  buildPythonPackage,
  python3Packages,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "helium";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "helium";
    tag = "v${version}";
    hash = "sha256-6RvHlcOhO9vnT7QF1Zl/R23ZdY6fSa63wwyRwSXS8J8=";
  };

  dependencies = [
    python3Packages.selenium
  ];

  pythonImportsCheck = [ "helium" ];

  meta = {
    description = "Lighter web automation with Python";
    homepage = "https://github.com/mherrmann/helium";
    changelog = "https://github.com/mherrmann/helium/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.joblade
    ];
  };
}
