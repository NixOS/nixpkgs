{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kinparse";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "kinparse";
    tag = version;
    hash = "sha256-170e2uhqpk6u/hahivWYubr3Ptb8ijymJSxhxrAfuyI=";
  };

  # Remove python2 build support as it breaks python >= 3.13
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "universal = 1" "universal = 0"
  '';

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  pythonRemoveDeps = [ "future" ];

  preCheck = ''
    substituteInPlace tests/test_kinparse.py \
      --replace-fail "data/" "$src/tests/data/"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kinparse" ];

  meta = {
    description = "Parser for KiCad EESCHEMA netlists";
    mainProgram = "kinparse";
    homepage = "https://github.com/xesscorp/kinparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
