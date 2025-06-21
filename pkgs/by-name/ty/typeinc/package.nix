{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "typeinc";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "Typeinc";
    tag = "v${version}";
    sha256 = "sha256-WxNI/2FNVYmeZC7YsaythYPjto+3bSCFOhP+OJ1tZw8=";
  };

  pyproject = true;
  build-system = [ python3Packages.hatchling ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    pyttsx3
    pyperclip
    keyboard
  ];

  meta = {
    description = "Terminal tool to test your typing speed with various difficulty levels";
    homepage = "https://github.com/AnirudhG07/Typeinc";
    mainProgram = "typeinc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
}
