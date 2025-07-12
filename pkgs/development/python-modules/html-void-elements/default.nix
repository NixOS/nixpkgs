{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "html-void-elements";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "html-void-elements";
    rev = version;
    hash = "sha256-Q5OEczTdgCCyoOsKv3MKRE3w4t/qyPG4YKbF19jlC88=";
  };

  nativeBuildInputs = [ poetry-core ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "HtmlVoidElements" ];

  meta = with lib; {
    description = "List of HTML void tag names";
    homepage = "https://github.com/Riverside-Healthcare/html-void-elements";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
