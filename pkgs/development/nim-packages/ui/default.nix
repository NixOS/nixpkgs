{ lib, buildNimPackage, fetchFromGitHub, libui, pkg-config }:

buildNimPackage rec {
  pname = "ui";
  version = "0.9.4";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = pname;
    rev = "547e1cea8e9fb68c138c422b77af0a3152e50210";
    hash = "sha256-rcvC0TO1r2zU7WEYfcsi/qX+nRITwKj7Fkqd4fHgTwU=";
  };
  propagatedBuildInputs = [ libui ];
  propagatedNativeBuildInputs = [ pkg-config ];
  postPatch = ''
    echo {.passL: r\"$(pkg-config --libs libui)\".} >> ui/rawui.nim
  '';
  meta = with lib;
    src.meta // {
      description = "Nim bindings to libui";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
