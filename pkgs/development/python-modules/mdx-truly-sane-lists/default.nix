{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown,
  python,
}:

buildPythonPackage rec {
  pname = "mdx_truly_sane_lists";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "radude";
    repo = "mdx_truly_sane_lists";
    rev = "refs/tags/${version}";
    hash = "sha256-hPnqF1UA4peW8hzeFiMlsBPfodC1qJXETGoq2yUm7d4=";
  };

  propagatedBuildInputs = [ markdown ];

  pythonImportsCheck = [ "mdx_truly_sane_lists" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} mdx_truly_sane_lists/tests.py
    runHook postCheck
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
