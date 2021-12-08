{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, substituteAll
, six
, withGraphviz ? true
, graphviz
, fontconfig
# Tests
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "anytree";
  version = "2.8.0";

  src = fetchFromGitHub {
     owner = "c0fec0de";
     repo = "anytree";
     rev = "2.8.0";
     sha256 = "145hlgvcncinpz75hnlxbf2ybm6p6fyya216rq883rb9gbas191r";
  };

  patches = lib.optionals withGraphviz [
    (substituteAll {
      src = ./graphviz.patch;
      inherit graphviz;
    })
  ];

  propagatedBuildInputs = [
    six
  ];

  # tests print “Fontconfig error: Cannot load default config file”
  preCheck = lib.optionalString withGraphviz ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  # circular dependency anytree → graphviz → pango → glib → gtk-doc → anytree
  doCheck = withGraphviz;

  checkInputs = [ pytestCheckHook nose ];

  pytestFlagsArray = lib.optionals (pythonOlder "3.4") [
    # Use enums, which aren't available pre-python3.4
    "--ignore=tests/test_resolver.py"
    "--ignore=tests/test_search.py"
  ];

  meta = with lib; {
    description = "Powerful and Lightweight Python Tree Data Structure";
    homepage = "https://github.com/c0fec0de/anytree";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
