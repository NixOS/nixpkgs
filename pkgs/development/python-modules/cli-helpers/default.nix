{
  lib,
  buildPythonPackage,
  fetchPypi,
  configobj,
  mock,
  pytestCheckHook,
  pygments,
  tabulate,
}:

buildPythonPackage rec {
  pname = "cli-helpers";
  version = "2.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "cli_helpers";
    inherit version;
    hash = "sha256-qYh0XsQx3a5wf3ON0NE4kLdKAKKqBCjqzX/B4Dsgahc=";
  };

  propagatedBuildInputs = [
    configobj
    tabulate
  ]
  ++ tabulate.optional-dependencies.widechars;

  optional-dependencies = {
    styles = [ pygments ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ]
  ++ lib.concatAttrValues optional-dependencies;

  meta = {
    description = "Python helpers for common CLI tasks";
    longDescription = ''
      CLI Helpers is a Python package that makes it easy to perform common
      tasks when building command-line apps. It's a helper library for
      command-line interfaces.

      Libraries like Click and Python Prompt Toolkit are amazing tools that
      help you create quality apps. CLI Helpers complements these libraries by
      wrapping up common tasks in simple interfaces.

      CLI Helpers is not focused on your app's design pattern or framework --
      you can use it on its own or in combination with other libraries. It's
      lightweight and easy to extend.

      What's included in CLI Helpers?

      - Prettyprinting of tabular data with custom pre-processing
      - [in progress] config file reading/writing

      Read the documentation at http://cli-helpers.rtfd.io
    '';
    homepage = "https://cli-helpers.readthedocs.io/en/stable/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.kalbasit ];
  };
}
