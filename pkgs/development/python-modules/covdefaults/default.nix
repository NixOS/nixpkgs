{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  coverage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "covdefaults";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "covdefaults";
    rev = "v${version}";
    hash = "sha256-/RqqvGL2a6sCNe5HrJ9Ty5SlingQ+dblVtGYd+z8ZKw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    coverage
  ];

  disabledTests = [
    # AttributeError: type object 'Plugins' has no attribute 'load_plugins'
    #
    # Apparently, known issue in coverage>=7.7.0, although I didn't find
    # changelog entry about it.
    #      ~kaction 2025-12-16
    #
    # => https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1107612
    "test_coverage_init"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A coverage plugin to provide sensible default settings";
    homepage = "https://github.com/asottile/covdefaults";
    license = licenses.mit;
    maintainers = [ ];
  };
}
