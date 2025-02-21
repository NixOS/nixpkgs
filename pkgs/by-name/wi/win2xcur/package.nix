{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "win2xcur";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "quantum5";
    repo = "win2xcur";
    rev = "v${version}";
    hash = "sha256-OjLj+QYg8YOJzDq3Y6/uyEXlNWbPm8VA/b1yP9jT6Jo=";
  };

  propagatedBuildInputs = with python3Packages; [ numpy wand ];

  meta = with lib; {
    description = "Tools that convert cursors between the Windows (*.cur, *.ani) and Xcursor format";
    homepage = "https://github.com/quantum5/win2xcur";
    changelog = "https://github.com/quantum5/win2xcur/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teatwig ];
  };
}
