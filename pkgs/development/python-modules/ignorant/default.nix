{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  httpx,
  setuptools,
  termcolor,
  tqdm,
  trio,
}:

buildPythonPackage rec {
  pname = "ignorant";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SLjED08uI+RjX+E0WHTQceReTEaY9WLPhXR3n0fP080=";
  };

  pythonRemoveDeps = [
    # https://github.com/megadose/ignorant/pull/37
    "argparse"
    # https://github.com/megadose/ignorant/pull/36
    "bs4"
  ];

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    httpx
    termcolor
    tqdm
    trio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ignorant" ];

  meta = {
    description = "Module to check if a phone number is used on different sites";
    homepage = "https://pypi.org/project/ignorant/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
