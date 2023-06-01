{ lib
, buildPythonPackage
, isPyPy
, fetchFromGitHub
, attrs
, exceptiongroup
, pexpect
, doCheck ? true
, pytestCheckHook
, pytest-xdist
, sortedcontainers
, pythonOlder
, sphinxHook
, sphinx-rtd-theme
, sphinx-hoverxref
, sphinx-codeautolink
, tzdata
# Used to break internal dependency loop.
, enableDocumentation ? true
}:

buildPythonPackage rec {
  pname = "hypothesis";
  version = "6.68.2";
  outputs = [ "out" ] ++ lib.optional enableDocumentation "doc";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "hypothesis-python-${version}";
    hash = "sha256-SgX8esTyC3ulFIv9mZJUoBA5hiv7Izr2hyD+NOudkpE=";
  };

  # I tried to package sphinx-selective-exclude, but it throws
  # error about "module 'sphinx' has no attribute 'directives'".
  #
  # It probably has to do with monkey-patching internals of Sphinx.
  # On bright side, this extension does not introduces new commands,
  # only changes "::only" command, so we probably okay with stock
  # implementation.
  #
  # I wonder how upstream of "hypothesis" builds documentation.
  postPatch = ''
    sed -i -e '/sphinx_selective_exclude.eager_only/ d' docs/conf.py
  '';

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  nativeBuildInputs = lib.optionals enableDocumentation [
    sphinxHook
    sphinx-rtd-theme
    sphinx-hoverxref
    sphinx-codeautolink
  ];

  propagatedBuildInputs = [
    attrs
    sortedcontainers
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  nativeCheckInputs = [
    pexpect
    pytest-xdist
    pytestCheckHook
  ] ++ lib.optionals (isPyPy) [
    tzdata
  ];

  inherit doCheck;

  # This file changes how pytest runs and breaks it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlagsArray = [
    "tests/cover"
  ];

  pythonImportsCheck = [
    "hypothesis"
  ];

  meta = with lib; {
    description = "Library for property based testing";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    changelog = "https://hypothesis.readthedocs.io/en/latest/changes.html#v${lib.replaceStrings [ "." ] [ "-" ] version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
