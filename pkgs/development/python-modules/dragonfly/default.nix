{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  json-rpc,
  kaldi-active-grammar,
  lark,
  packaging,
  psutil,
  pynput,
  pyperclip,
  pythonOlder,
  regex,
  requests,
  setuptools,
  six,
  sounddevice,
  webrtcvad,
  werkzeug,
  wmctrl,
  xdotool,
  xorg,
}:

buildPythonPackage rec {
  pname = "dragonfly";
  version = "0.35.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dictation-toolbox";
    repo = "dragonfly";
    tag = version;
    hash = "sha256-sqEEEr5/KG3cn4rmOGJt9zMNAjeLO6h3NJgg0EyewrM=";
  };

  postPatch = ''
    substituteInPlace dragonfly/actions/keyboard/_x11_xdotool.py \
      --replace-fail 'xdotool = "xdotool"'${" "}'xdotool = "${xdotool}/bin/xdotool"'
    substituteInPlace dragonfly/windows/x11_window.py \
      --replace-fail 'xdotool = "xdotool"'${" "}'xdotool = "${xdotool}/bin/xdotool"' \
      --replace-fail 'xprop = "xprop"'${" "}'xprop = "${xorg.xprop}/bin/xprop"' \
      --replace-fail 'wmctrl = "wmctrl"'${" "}'wmctrl = "${wmctrl}/bin/wmctrl"'
  '';

  pythonRemoveDeps = [ "lark-parser" ];

  propagatedBuildInputs = [
    decorator
    json-rpc
    lark
    packaging
    psutil
    pynput
    pyperclip
    regex
    requests
    setuptools # needs pkg_resources at runtime
    six
    werkzeug
  ];

  optional-dependencies = {
    kaldi = [
      kaldi-active-grammar
      sounddevice
      webrtcvad
    ];
  };

  # Too many tests fail because of the unusual environment or
  # because of the missing dependencies for some of the engines.
  doCheck = false;

  pythonImportsCheck = [ "dragonfly" ];

  meta = with lib; {
    description = "Speech recognition framework allowing powerful Python-based scripting";
    homepage = "https://github.com/dictation-toolbox/dragonfly";
    changelog = "https://github.com/dictation-toolbox/dragonfly/blob/${version}/CHANGELOG.rst";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
