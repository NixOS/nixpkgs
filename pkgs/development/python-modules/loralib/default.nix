{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  torch,
}:
buildPythonPackage rec {
  pname = "loralib";
  version = "0-unstable-2024-01-09";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "LoRA";
    rev = "4c0333854cb905966f8cc4e9a74068c1e507c7b7";
    hash = "sha256-zx2IXcQcLCuVytMhGDhYEZGAV7AuQ6QWlOPlueUZjzM=";
  };

  propagatedBuildInputs = [
    torch
  ];

  pythonImportsCheck = [ "loralib" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Implementation of \"LoRA: Low-Rank Adaptation of Large Language Models\"";
    homepage = "https://arxiv.org/abs/2106.09685";
    license = with lib.licenses; [ mit ];
  };
}
