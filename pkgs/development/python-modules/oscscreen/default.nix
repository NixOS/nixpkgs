{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oscscreen";
  version = "unstable-2023-03-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "npyscreen";
    rev = "e2a97e4a201e2d7d5de3ee033071a7f93592b422";
    hash = "sha256-0Im1kVFa11AW+7Oe95XvkfxSlaux6bkKaHSQy6hJCN8=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "oscscreen" ];

  meta = with lib; {
    description = "Framework for developing console applications using Python and curses";
    homepage = "http://github.com/outscale/npyscreen";
    changelog = "https://github.com/outscale/npyscreen/blob/${src.rev}/CHANGELOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nicolas-goudry ];
  };
}
