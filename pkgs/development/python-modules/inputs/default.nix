{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "inputs";
  version = "0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zeth";
    repo = "inputs";
    rev = "v${version}";
    hash = "sha256-tU1R6lhSMZj3Y6XdrT/Yfbte/BdLDvo6TzvLbnr+1vo=";
  };

  pythonImportsCheck = [ "inputs" ];

  meta = with lib; {
    description = "Cross-platform Python support for keyboards, mice and gamepads";
    homepage = "https://github.com/zeth/inputs";
    changelog = "https://github.com/zeth/inputs/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
