{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fpyutils,
  pyfakefs,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "md-toc";
  version = "8.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = "md-toc";
    tag = version;
    hash = "sha256-nKkKtLEW0pohXiMtjWl2Kzh7SRwZJ/yzhXpDyluLodc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ fpyutils ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  enabledTestPaths = [ "md_toc/tests/*.py" ];

  pythonImportsCheck = [ "md_toc" ];

  meta = with lib; {
    description = "Table of contents generator for Markdown";
    mainProgram = "md_toc";
    homepage = "https://docs.franco.net.eu.org/md-toc/";
    changelog = "https://blog.franco.net.eu.org/software/CHANGELOG-md-toc.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
