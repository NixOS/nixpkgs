{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bibtexparser,
  requests,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "rebiber";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuchenlin";
    repo = "rebiber";
    rev = "v${finalAttrs.version}";
    hash = "sha256-feV6xVb9g2rDG7cPYvccVmJsJMGpevVTYDD82OCcR6Y=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bibtexparser
    requests
    tqdm
  ];

  pythonImportsCheck = [ "rebiber" ];

  meta = {
    description = "Simple tool to update bib entries with their official information (e.g., DBLP or the ACL anthology)";
    homepage = "https://github.com/yuchenlin/rebiber";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
})
