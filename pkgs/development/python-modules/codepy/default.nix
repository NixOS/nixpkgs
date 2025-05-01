{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  cgen,
  numpy,
  pytools,
  platformdirs,
  typing-extensions,
  boost,
  ruff,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "codepy";
  version = "2025.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-PHIC3q9jQlRRoUoemVtyrl5hcZXMX28gRkI5Xpk9yBY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    cgen
    numpy
    pytools
    platformdirs
    typing-extensions
    # boost is needed for generating boostPython code
    boost
  ];

  pythonImportsCheck = [ "codepy" ];

  nativeCheckInputs = [
    ruff
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    homepage = "https://github.com/inducer/codepy";
    description = "Generate and execute native code at run time, from Python";
    changelog = "https://github.com/inducer/codepy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    # Dynamic compilation and linking are so far only supported in Linux with the GNU toolchain.
    # See https://github.com/inducer/codepy/blob/c23f44dd3986f7d3d116df88dc5097404f639256/README.rst?plain=1#L14.
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ atila ];
  };
}
