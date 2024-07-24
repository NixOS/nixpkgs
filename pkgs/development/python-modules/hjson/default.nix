{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  makeWrapper,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hjson";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-VrCLHfXShF45IEhGVQpryBzjxreQEunyghazDNKRh8k=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hjson" ];

  postInstall = ''
    rm $out/bin/hjson.cmd
    wrapProgram $out/bin/hjson  \
      --set PYTHONPATH "$PYTHONPATH" \
      --prefix PATH : ${lib.makeBinPath [ python ]}
  '';

  disabledTestPaths = [
    # AttributeError:  b'/build/source/hjson/tool.py:14: Deprecati[151 chars]ools' != b''
    "hjson/tests/test_tool.py"
  ];

  meta = with lib; {
    description = "User interface for JSON";
    homepage = "https://github.com/hjson/hjson-py";
    changelog = "https://github.com/hjson/hjson-py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
    mainProgram = "hjson";
  };
}
