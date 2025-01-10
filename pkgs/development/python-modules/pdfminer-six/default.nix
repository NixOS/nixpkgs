{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
