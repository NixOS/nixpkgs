{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  cryptography,
  charset-normalizer,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  substituteAll,
  ocrmypdf,
}:

buildPythonPackage rec {
  pname = "pdfminer-six";
  version = "20240706";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = "refs/tags/${version}";
    hash = "sha256-aY7GQADRxeiclr6/G3RRgrPcl8rGiC85JYEIjIa+vG0=";
  };

  patches = [
    # https://github.com/pdfminer/pdfminer.six/pull/1027
    (fetchpatch2 {
      name = "fix-dereference-MediaBox.patch";
      url = "https://github.com/pdfminer/pdfminer.six/pull/1027/commits/ad101c152c71431a21bfa5a8dbe33b3ba385ceec.patch?full_index=1";
      excludes = [ "CHANGELOG.md" ];
      hash = "sha256-fsSXvN92MVtNFpAst0ctvGrbxVvoe4Nyz4wMZqJ1aw8=";
    })
    (substituteAll {
      src = ./disable-setuptools-git-versioning.patch;
      inherit version;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    cryptography
  ];

  postInstall = ''
    for file in $out/bin/*.py; do
      ln $file ''${file//.py/}
    done
  '';

  pythonImportsCheck = [
    "pdfminer"
    "pdfminer.high_level"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # The binary file samples/contrib/issue-1004-indirect-mediabox.pdf is
    # stripped from fix-dereference-MediaBox.patch.
    "test_contrib_issue_1004_mediabox"
  ];

  passthru = {
    tests = {
      inherit ocrmypdf;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/pdfminer/pdfminer.six/blob/${src.rev}/CHANGELOG.md";
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
