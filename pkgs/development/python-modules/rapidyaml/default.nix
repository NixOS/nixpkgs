{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  swig,
  cmake-build-extension,
  setuptools,
  setuptools-git,
  setuptools-scm,
  deprecation,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rapidyaml";
  version = "0.15.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = "rapidyaml-python";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-lTLVcB6LJKY2gIg2l8/B/hrl0Cu2Ia5d/I1z6jyZ2KM=";
  };

  build-system = [
    setuptools
    cmake-build-extension
    setuptools-scm
    setuptools-git
    swig
  ];

  postPatch = ''
    # pyproject.toml lists "swig" as a Python build requirement (for PyPI installs),
    # but in Nix swig is a system binary on PATH, not a Python package. Remove it so
    # pypa/build's dependency check doesn't fail when using --no-isolation.
    substituteInPlace pyproject.toml \
      --replace-fail '"swig"' ""
  '';

  # cmake-build-extension drives the CMake configure step
  dontUseCmakeConfigure = true;

  dependencies = [ deprecation ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ryml" ];

  meta = {
    description = "Parse and emit YAML, and do it fast. Python wrapper for the C++ library";
    homepage = "https://github.com/biojppm/rapidyaml-python";
    changelog = "https://github.com/biojppm/rapidyaml-python/blob/master/changelog/${finalAttrs.version}.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
