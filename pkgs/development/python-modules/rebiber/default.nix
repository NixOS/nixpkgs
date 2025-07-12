{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bibtexparser,
  tqdm,
}:

buildPythonPackage {
  pname = "rebiber";
  version = "1.1.3-unstable-2025-05-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuchenlin";
    repo = "rebiber";
    rev = "f5e7a2b4b4bac7c8b111c1b75080c1bcb5c8b08d";
    hash = "sha256-SzVyY9L/tFImJP0GOVMNcvlccyyQvL4UURoqwpT0qL0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bibtexparser
    tqdm
  ];

  pythonImportsCheck = [ "rebiber" ];

  meta = {
    description = "Simple tool to update bib entries with their official information (e.g., DBLP or the ACL anthology)";
    homepage = "https://github.com/yuchenlin/rebiber";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
