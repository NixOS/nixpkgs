{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,

  # build-system
  pdm-backend,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  test2ref,
  fontconfig,
}:

buildPythonPackage rec {
  pname = "anytree";
  version = "2.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "c0fec0de";
    repo = "anytree";
    tag = version;
    hash = "sha256-kFNYJMWagpqixs84+AaNkh/28asLBJhibTP8LEEe4XY=";
  };

  postPatch = ''
    substituteInPlace src/anytree/exporter/dotexporter.py \
      --replace-fail \
        'cmd = ["dot"' \
        'cmd = ["${lib.getExe' graphviz "dot"}"'
  '';

  build-system = [ pdm-backend ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pyyaml
    test2ref
  ];

  # Tests print “Fontconfig error: Cannot load default config file”
  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  pythonImportsCheck = [ "anytree" ];

  meta = {
    description = "Powerful and Lightweight Python Tree Data Structure";
    homepage = "https://github.com/c0fec0de/anytree";
    changelog = "https://github.com/c0fec0de/anytree/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maitnainers; [ ];
  };
}
