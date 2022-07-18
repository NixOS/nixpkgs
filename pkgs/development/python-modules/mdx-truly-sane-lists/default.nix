{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # fix with markdown>=3.4
    # Upstream PR: https://github.com/radude/mdx_truly_sane_lists/pull/12/
    (fetchpatch {
      url = "https://github.com/radude/mdx_truly_sane_lists/commit/197fa16bc8d3481b8ea29d54b9cc89716f5d43a2.patch";
      sha256 = "sha256-cYCb+EI4RpebNN02bCy1SSH9Tz4BsnFgUCOeQNC03Oo=";
    })
  ];

  propagatedBuildInputs = [ markdown ];

  pythonImportsCheck = [ "mdx_truly_sane_lists" ];

  # Hard ImportError from the package trying to view version of markdown,
  # which was removed.
  # Upstream issue: https://github.com/radude/mdx_truly_sane_lists/issues/11
  doCheck = false;
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
