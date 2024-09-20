{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  commandlines,
  unittestCheckHook,
  pexpect,
  naked,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "hsh";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "hsh";
    rev = "v${version}";
    hash = "sha256-bAAytoidFHH2dSXqN9aqBd2H4p/rwTWXIZa1t5Djdz0=";
  };

  propagatedBuildInputs = [ commandlines ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    unittestCheckHook
    pexpect
    naked
  ];

  preCheck = "cd tests";

  pythonImportsCheck = [ "hsh" ];

  meta = with lib; {
    description = "Cross-platform command line application that generates file hash digests and performs file integrity checks via file hash digest comparisons";
    homepage = "https://github.com/chrissimpkins/hsh";
    downloadPage = "https://github.com/chrissimpkins/hsh/releases";
    license = licenses.mit;
    maintainers = [ maintainers.lucasew ];
  };
}
