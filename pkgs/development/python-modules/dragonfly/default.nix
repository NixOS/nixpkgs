{ lib
, buildPythonPackage
, fetchFromGitHub
, decorator
, packaging
, pynput
, regex
, lark
, enum34
, pyperclip
, six
, requests
, psutil
, json-rpc
, werkzeug
, kaldi-active-grammar
, sounddevice
, webrtcvad
, setuptools
, xdotool
, wmctrl
, xorg
}:

buildPythonPackage rec {
  pname = "dragonfly";
  version = "0.35.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dictation-toolbox";
    repo = pname;
    rev = version;
    hash = "sha256-sqEEEr5/KG3cn4rmOGJt9zMNAjeLO6h3NJgg0EyewrM=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'lark-parser == 0.8.*' 'lark'
    substituteInPlace dragonfly/actions/keyboard/_x11_xdotool.py \
      --replace 'xdotool = "xdotool"'${" "}'xdotool = "${xdotool}/bin/xdotool"'
    substituteInPlace dragonfly/windows/x11_window.py \
      --replace 'xdotool = "xdotool"'${" "}'xdotool = "${xdotool}/bin/xdotool"' \
      --replace 'xprop = "xprop"'${" "}'xprop = "${xorg.xprop}/bin/xprop"' \
      --replace 'wmctrl = "wmctrl"'${" "}'wmctrl = "${wmctrl}/bin/wmctrl"'
  '';

  propagatedBuildInputs = [
    decorator
    packaging
    pynput
    regex
    lark
    enum34
    pyperclip
    six
    requests
    psutil
    json-rpc
    werkzeug
    kaldi-active-grammar # for the Kaldi engine
    sounddevice
    webrtcvad
    setuptools # needs pkg_resources at runtime
  ];

  # Too many tests fail because of the unusual environment or
  # because of the missing dependencies for some of the engines.
  doCheck = false;

  pythonImportsCheck = [ "dragonfly" ];

  meta = with lib; {
    description = "Speech recognition framework allowing powerful Python-based scripting";
    homepage = "https://github.com/dictation-toolbox/dragonfly";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ckie ];
  };
}
