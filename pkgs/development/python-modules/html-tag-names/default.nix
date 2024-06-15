{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "html-tag-names";
  version = "0.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "html-tag-names";
    rev = version;
    hash = "sha256-2YywP4/0yocejuJwanC5g9BR7mcy5C+zMhCjNZ9FRH4=";
  };

  nativeBuildInputs = [ poetry-core ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "HtmlTagNames" ];

  meta = with lib; {
    description = "List of known HTML tags";
    homepage = "https://github.com/Riverside-Healthcare/html-tag-names";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
