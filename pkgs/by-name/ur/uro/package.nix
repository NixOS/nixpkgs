{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "uro";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "uro";
    rev = version;
    hash = "sha256-aDFUyWkje4TqsmxnPfQAhf2k4rFMdibxfHHvQks9yRA=";
  };

  build-system = [ python3Packages.setuptools ];

  meta = {
    description = "declutters url lists for crawling/pentesting";
    homepage = "https://github.com/s0md3v/uro";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.michaelBelsanti ];
    mainProgram = "uro";
  };
}
