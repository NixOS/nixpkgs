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
  pythonOlder,
  quantiphy,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "nestedtext";
  version = "3.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "nestedtext";
    rev = "refs/tags/v${version}";
    hash = "sha256-lNqSmEmzuRGdXs/4mwKSh7yDGHnAykpIDIR+abbLCns=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ inform ];

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

  pytestFlagsArray = [
    # Avoids an ImportMismatchError.
    "--ignore=build"
  ];

  disabledTestPaths = [
    # Examples are prefixed with test_
    "examples/"
  ];

  passthru.tests = {
    runTests = nestedtext.overrideAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "nestedtext" ];

  meta = with lib; {
    description = "A human friendly data format";
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
    changelog = "https://github.com/KenKundert/nestedtext/blob/v${version}/doc/releases.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
