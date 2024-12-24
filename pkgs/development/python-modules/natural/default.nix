{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  six,
  django,
}:
buildPythonPackage rec {
  pname = "natural";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "natural";
    rev = "refs/tags/${version}";
    hash = "sha256-DERFKDGVUPcjYAxiTYWgWkPp+Myd/9CNytQWgRya570=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ django ];

  meta = {
    description = "Convert data to their natural (human-readable) format";
    homepage = "https://github.com/tehmaze/natural";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sailord
      vinetos
    ];
  };
}
