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
<<<<<<< HEAD
, python
, sortedcontainers
, stdenv
=======
, sortedcontainers
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, sphinxHook
, sphinx-rtd-theme
, sphinx-hoverxref
, sphinx-codeautolink
, tzdata
<<<<<<< HEAD
=======
# Used to break internal dependency loop.
, enableDocumentation ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "hypothesis";
  version = "6.68.2";
<<<<<<< HEAD
  outputs = [ "out" ];
=======
  outputs = [ "out" ] ++ lib.optional enableDocumentation "doc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  nativeBuildInputs = lib.optionals enableDocumentation [
    sphinxHook
    sphinx-rtd-theme
    sphinx-hoverxref
    sphinx-codeautolink
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ] ++ lib.optionals isPyPy [
=======
  ] ++ lib.optionals (isPyPy) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru = {
    doc = stdenv.mkDerivation {
      # Forge look and feel of multi-output derivation as best as we can.
      #
      # Using 'outputs = [ "doc" ];' breaks a lot of assumptions.
      name = "${pname}-${version}-doc";
      inherit src pname version;

      postInstallSphinx = ''
        mv $out/share/doc/* $out/share/doc/python$pythonVersion-$pname-$version
      '';

      nativeBuildInputs = [
        sphinxHook
        sphinx-rtd-theme
        sphinx-hoverxref
        sphinx-codeautolink
      ];

      inherit (python) pythonVersion;
      inherit meta;
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Library for property based testing";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    changelog = "https://hypothesis.readthedocs.io/en/latest/changes.html#v${lib.replaceStrings [ "." ] [ "-" ] version}";
    license = licenses.mpl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
