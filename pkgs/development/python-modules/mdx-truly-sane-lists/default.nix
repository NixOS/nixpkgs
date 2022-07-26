{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
, python
}:

buildPythonPackage rec {
  pname = "mdx_truly_sane_lists";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "radude";
    repo = "mdx_truly_sane_lists";
    rev = version;
    sha256 = "1h8403ch016cwdy5zklzp7c6xrdyyhl4z07h97qzbafrbq07jyss";
  };

  propagatedBuildInputs = [ markdown ];

  pythonImportsCheck = [ "mdx_truly_sane_lists" ];

  checkPhase = ''
    ${python.interpreter} mdx_truly_sane_lists/tests.py
  '';

  meta = with lib; {
    description = "Extension for Python-Markdown that makes lists truly sane.";
    longDescription = ''
      Features custom indents for nested lists and fix for messy linebreaks and
      paragraphs between lists.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
