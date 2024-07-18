{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  gnupg,
  python-dateutil,
  pythonOlder,
  pytestCheckHook,
  regex,
}:

buildPythonPackage rec {
  version = "2.3.6";
  format = "setuptools";
  pname = "beancount";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gB+Tvta1fS4iQ2aIxInVob8fduIQ887RhoB1fmDTR1o=";
  };

  patches = [
    ./subprocess_python.patch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    gnupg
  ];

  disabledTests = [
    "test_hash_parser_source_files" # AssertionError: False is not true
    "test_export_basic" # ValueError: Failed to find the root directory.
    "test_example_files" # ValueError: Failed to find the root directory.
    # for all tests below: AssertionError 2 != 0
    "test_linked_explicit_link"
    "test_linked_lineno_only"
    "test_linked_multiple_files"
  ];

  preCheck = ''
    cd $out
  '';

  dependencies = [
    click
    python-dateutil
    regex
  ];

  meta = {
    homepage = "https://github.com/beancount/beancount";
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
      A double-entry bookkeeping computer language that lets you define
      financial transaction records in a text file, read them in memory,
      generate a variety of reports from them, and provides a web interface.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
