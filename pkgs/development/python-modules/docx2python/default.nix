{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "docx2python";
  version = "unstable-2020-11-15";

  # Pypi does not contain tests
  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = pname;
    rev = "21b2edafc0a01a6cfb73aefc61747a65917e2cad";
    sha256 = "1nwg17ziwm9a2x7yxsscj8zgc1d383ifsk5w7qa2fws6gf627kyi";
  };

  preCheck = "cd test"; # Tests require the `test/resources` folder to be accessible
  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [ # asserts related to file deletions fail
    "test_docx2python.py"
    "test_docx_context.py"
    "test_google_docs.py"
  ];
  pythonImportsCheck = [ "docx2python" ];

  meta = with lib; {
    homepage = "https://github.com/ShayHill/docx2python";
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    maintainers = [ maintainers.ivar ];
    license = licenses.mit;
  };
}
