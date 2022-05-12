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
  pname = "pdfminer_six";
  version = "20220506";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "sha256-Lq+ou7+Lmr1H69L8X/vuky+/tXDD3bBBaCysymeRuXA=";
  };

  propagatedBuildInputs = [ charset-normalizer cryptography ];

  postInstall = ''
    for file in $out/bin/*.py; do
      ln $file ''${file//.py/}
    done
  '';

  postPatch = ''
    # Version is not stored in repo, gets added by a GitHub action after tag is created
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
