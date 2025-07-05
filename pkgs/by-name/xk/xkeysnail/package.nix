{
  lib,
  fetchFromGitHub,
  python3Packages,
  fetchpatch,
}:

python3Packages.buildPythonApplication {
  pname = "xkeysnail";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mooz";
    repo = "xkeysnail";
    rev = "bf3c93b4fe6efd42893db4e6588e5ef1c4909cfb";
    hash = "sha256-12AkB6Zb1g9hY6mcphO8HlquxXigiiFhadr9Zsm6jF4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mooz/xkeysnail/commit/457ab424fb32c4bfc6e6ea307752a2ce5d77853b.patch";
      hash = "sha256-yqsAfn3SibRW2clbtVwVZi1dJ8pAiXoYpittpz7S/wU=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    evdev
    xlib
    inotify-simple
    appdirs
  ];

  postInstall = ''
    install -Dm444 ${./emacs.py} $out/share/browser.py

    makeWrapper $out/bin/xkeysnail $out/bin/xkeysnail-browser \
      --add-flags "-q" --add-flags "$out/share/browser.py"
  '';

  meta = {
    description = "Yet another keyboard remapping tool for X environment";
    homepage = "https://github.com/mooz/xkeysnail";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ bb2020 ];
  };
}
