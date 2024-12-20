{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "vcsi";
  version = "7.0.16";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "amietn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I0o6GX/TNMfU+rQtSqReblRplXPynPF6m2zg0YokmtI=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pillow
    jinja2
    texttable
    parsedatetime
  ];

  doCheck = false;
  pythonImportsCheck = [ "vcsi" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  meta = with lib; {
    description = "Create video contact sheets";
    homepage = "https://github.com/amietn/vcsi";
    license = licenses.mit;
    maintainers = with maintainers; [
      dandellion
      zopieux
    ];
    mainProgram = "vcsi";
  };
}
