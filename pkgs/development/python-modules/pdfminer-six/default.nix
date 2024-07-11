{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  isPy3k,
  cryptography,
  charset-normalizer,
  pythonOlder,
  typing-extensions,
  pytestCheckHook,
  setuptools,
  substituteAll,
  ocrmypdf,
}:

buildPythonPackage rec {
  pname = "pdfminer-six";
  version = "20231228";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    hash = "sha256-LXPECQQojD3IY9zRkrDBufy4A8XUuYiRpryqUx/I3qo=";
  };

  patches = [
    (substituteAll {
      src = ./disable-setuptools-git-versioning.patch;
      inherit version;
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs =
    [
      charset-normalizer
      cryptography
    ]
    ++ lib.optionals (pythonOlder "3.8") [
      importlib-metadata
      typing-extensions
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
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
