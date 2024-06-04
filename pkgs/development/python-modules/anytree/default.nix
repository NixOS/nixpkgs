{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  graphviz,
  poetry-core,
  pytest7CheckHook,
  pythonOlder,
  six,
  substituteAll,
  withGraphviz ? true,
}:

buildPythonPackage rec {
  pname = "anytree";
  version = "2.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "c0fec0de";
    repo = "anytree";
    rev = "refs/tags/${version}";
    hash = "sha256-5HU8kR3B2RHiGBraQ2FTgVtGHJi+Lha9U/7rpNsYCCI=";
  };

  patches = lib.optionals withGraphviz [
    (substituteAll {
      src = ./graphviz.patch;
      inherit graphviz;
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest7CheckHook ];

  # Tests print “Fontconfig error: Cannot load default config file”
  preCheck = lib.optionalString withGraphviz ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  # Circular dependency anytree → graphviz → pango → glib → gtk-doc → anytree
  doCheck = withGraphviz;

  pythonImportsCheck = [ "anytree" ];

  meta = with lib; {
    description = "Powerful and Lightweight Python Tree Data Structure";
    homepage = "https://github.com/c0fec0de/anytree";
    changelog = "https://github.com/c0fec0de/anytree/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maitnainers; [ ];
  };
}
