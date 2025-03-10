{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  hatchling,
  sphinx,
  libclang,
  strictyaml,
  clang,
}:

buildPythonPackage rec {
  pname = "hawkmoth";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jnikula";
    repo = "hawkmoth";
    tag = "v${version}";
    hash = "sha256-YTFO8Na4MckGdUWcNVHNdbCwt/W8oOK+U4QKp+DMW3Y=";
  };
  patches = [
    (fetchpatch {
      # TODO remove this test fixes backports on version bump.
      name = "test-fix-header-search-paths-in-tests.diff";
      url = "https://github.com/jnikula/hawkmoth/compare/9d5f3df9856bf88810c3f57eee28dcd65adef26e...8f0431b7e069a19bbed63e3d26176470293d38a5.diff";
      hash = "sha256-kQSaSYcfhLmlgsjUeh/abGf+8ueKoUQfsNqfp0QIXAk=";
    })
  ];

  build-system = [ hatchling ];

  dependencies = [
    sphinx
    libclang
  ];

  nativeCheckInputs = [
    pytestCheckHook
    strictyaml
    clang
  ];
  pytestFlags = [ "--rootdir=test" ];
  pythonImportsCheck = [ "hawkmoth" ];

  meta = {
    description = "Sphinx Autodoc for C";
    homepage = "https://jnikula.github.io/hawkmoth/";
    changelog = "https://github.com/jnikula/hawkmoth/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.cynerd ];
  };
}
