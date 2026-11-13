{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  flit-core,
  hypothesis,
  inform,
  nestedtext,
  pytestCheckHook,
  quantiphy,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "nestedtext";
  version = "3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "nestedtext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eg5Q11dl9ikGpNYx2Sd47MBPC9S4W2M6PpehFpowzdk=";
  };

  build-system = [ flit-core ];

  dependencies = [ inform ];

  nativeCheckInputs = [
    docopt
    hypothesis
    quantiphy
    pytestCheckHook
    voluptuous
  ];

  # Tests depend on quantiphy. To avoid infinite recursion, tests are only
  # enabled when building passthru.tests.
  doCheck = false;

  disabledTestPaths = [
    # Avoids an ImportMismatchError.
    "build"
    # Examples are prefixed with test_
    "examples/"
  ];

  passthru.tests = {
    runTests = nestedtext.overrideAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "nestedtext" ];

  meta = {
    description = "Human friendly data format";
    longDescription = ''
      NestedText is a file format for holding data that is to be entered,
      edited, or viewed by people. It allows data to be organized into a nested
      collection of dictionaries, lists, and strings. In this way it is similar
      to JSON, YAML and TOML, but without the complexity and risk of YAML and
      without the syntactic clutter of JSON and TOML. NestedText is both simple
      and natural. Only a small number of concepts and rules must be kept in
      mind when creating it. It is easily created, modified, or viewed with a
      text editor and easily understood and used by both programmers and
      non-programmers.
    '';
    homepage = "https://nestedtext.org";
    changelog = "https://github.com/KenKundert/nestedtext/blob/${finalAttrs.src.tag}/doc/releases.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jeremyschlatter ];
  };
})
