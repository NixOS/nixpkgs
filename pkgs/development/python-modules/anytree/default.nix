{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, fontconfig
, graphviz
, poetry-core
, pytestCheckHook
, pythonOlder
, six
, substituteAll
, withGraphviz ? true
=======
, fetchPypi
, pythonOlder
, substituteAll
, six
, withGraphviz ? true
, graphviz
, fontconfig
# Tests
, pytestCheckHook
, nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "anytree";
<<<<<<< HEAD
  version = "2.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "c0fec0de";
    repo = "anytree";
    rev = "refs/tags/${version}";
    hash = "sha256-e7mmOOvrZuMCcyUg74YLLXGzkb5nCtuYmhNzAbY65gg=";
=======
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = lib.optionals withGraphviz [
    (substituteAll {
      src = ./graphviz.patch;
      inherit graphviz;
    })
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    poetry-core
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    six
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests print “Fontconfig error: Cannot load default config file”
=======
  # tests print “Fontconfig error: Cannot load default config file”
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = lib.optionalString withGraphviz ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

<<<<<<< HEAD
  # Circular dependency anytree → graphviz → pango → glib → gtk-doc → anytree
  doCheck = withGraphviz;

  pythonImportsCheck = [
    "anytree"
=======
  # circular dependency anytree → graphviz → pango → glib → gtk-doc → anytree
  doCheck = withGraphviz;

  nativeCheckInputs = [ pytestCheckHook nose ];

  pytestFlagsArray = lib.optionals (pythonOlder "3.4") [
    # Use enums, which aren't available pre-python3.4
    "--ignore=tests/test_resolver.py"
    "--ignore=tests/test_search.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Powerful and Lightweight Python Tree Data Structure";
    homepage = "https://github.com/c0fec0de/anytree";
<<<<<<< HEAD
    changelog = "https://github.com/c0fec0de/anytree/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maitnainers; [ ];
=======
    license = licenses.asl20;
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
