{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "viw";
  version = "0-unstable-2017-10-29";

  src = fetchFromGitHub {
    owner = "lpan";
    repo = "viw";
    rev = "2cf317f6d82a6fa58f284074400297b6dc0f44c2";
    sha256 = "0bnkh57v01zay6ggk0rbddaf75i48h8z06xsv33wfbjldclaljp1";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  checkFlags = [
    "test-command"
    "test-buffer"
    "test-state"
  ];

  installPhase = ''
    install -Dm 755 -t $out/bin viw
    install -Dm 644 -t $out/share/doc/viw README.md
  '';

  meta = with lib; {
    description = "VI Worsened, a fun and light clone of VI";
    homepage = "https://github.com/lpan/viw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "viw";
  };
}
