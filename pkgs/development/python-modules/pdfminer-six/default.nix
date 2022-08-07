{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, cryptography
, charset-normalizer
, pytestCheckHook
, ocrmypdf
}:

buildPythonPackage rec {
  pname = "pdfminer-six";
  version = "20220524";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "sha256-XO9sdHeS/8MgVW0mxbTe2AY5BDfnBSDNzZwLsSKmQh0=";
  };

  propagatedBuildInputs = [ charset-normalizer cryptography ];

  postInstall = ''
    for file in $out/bin/*.py; do
      ln $file ''${file//.py/}
    done
  '';

  postPatch = ''
    # Verion is not stored in repo, gets added by a GitHub action after tag is created
    # https://github.com/pdfminer/pdfminer.six/pull/727
    substituteInPlace pdfminer/__init__.py --replace "__VERSION__" ${version}
  '';

  pythonImportsCheck = [ "pdfminer" ];

  checkInputs = [ pytestCheckHook ];

  passthru = {
    tests = {
      inherit ocrmypdf;
    };
  };

  meta = with lib; {
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy marsam ];
  };
}
