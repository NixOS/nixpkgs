{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  base58,
  bitstring,
  coincurve,
  cryptography,
  pysocks,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyln-proto";
  version = "26.06.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ElementsProject";
    repo = "lightning";
    tag = "v${version}";
    hash = "sha256-RhCe8m0/1ge0r6pNa3oQENg2wu8UvRtERqX5QJsHQjo=";
  };

  postUnpack = ''
    sourceRoot=$sourceRoot/contrib/pyln-proto
  '';

  # Upstream uses this fork for Python 3.14 wheels; nixpkgs builds coincurve
  # from source and does not need the fork.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'coincurve-cp314-fix' 'coincurve'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "coincurve" ];

  dependencies = [
    base58
    bitstring
    coincurve
    cryptography
    pysocks
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "pyln" ];

  pythonImportsCheck = [ "pyln.proto" ];

  meta = {
    description = "Lightning Network protocol library for testing and tooling";
    homepage = "https://github.com/ElementsProject/lightning/tree/master/contrib/pyln-proto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
