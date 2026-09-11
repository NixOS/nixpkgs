{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage {
  pname = "anchor-kr";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justfoolingaround";
    repo = "anchor";
    # Using the commit hash because upstream does not have releases. https://github.com/justfoolingaround/anchor/issues/1
    rev = "4cedb6a51877ed3a292cad61eb19013382915e86";
    hash = "sha256-t75IFBSz6ncHRqXRxbrM9EQdr8xPXjSd9di+/y2LegE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "anchor" ];

  meta = {
    description = "Python library for scraping";
    homepage = "https://github.com/justfoolingaround/anchor";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ passivelemon ];
  };
}
