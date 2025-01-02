{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "xkeysnail";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mooz";
    repo = pname;
    rev = "bf3c93b4fe6efd42893db4e6588e5ef1c4909cfb";
    sha256 = "0plcpb4ndzfsd5hj32m0g32swnhyph9sd759cdhhzmjvlq3j8q6p";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = with python3Packages; [
    evdev
    xlib
    inotify-simple
    appdirs
  ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share
    cp ./example/config.py $out/share/example.py
    cp ${./browser-emacs-bindings.py} $out/share/browser.py

    makeWrapper $out/bin/xkeysnail $out/bin/xkeysnail-example \
      --add-flags "-q" --add-flags "$out/share/example.py"
    makeWrapper $out/bin/xkeysnail $out/bin/xkeysnail-browser \
      --add-flags "-q" --add-flags "$out/share/browser.py"
  '';

  meta = with lib; {
    description = "Yet another keyboard remapping tool for X environment";
    homepage = "https://github.com/mooz/xkeysnail";
    platforms = platforms.linux;
    license = licenses.gpl1Only;
    maintainers = with maintainers; [ bb2020 ];
  };
}
