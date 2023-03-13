{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, cryptography
, charset-normalizer
, pythonOlder
, typing-extensions
, pytestCheckHook
, ocrmypdf
}:

buildPythonPackage rec {
  pname = "pdfminer-six";
  version = "20221105";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "sha256-OyEeQBuYfj4iEcRt2/daSaUfTOjCVSCyHW2qffal+Bk=";
  };

  propagatedBuildInputs = [
    charset-normalizer
    cryptography
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

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

  pythonImportsCheck = [
    "pdfminer"
    "pdfminer.high_level"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
