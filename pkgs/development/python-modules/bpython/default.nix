{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  curtsies,
  cwcwidth,
  greenlet,
  jedi,
  pygments,
  pytestCheckHook,
  pyperclip,
  pyxdg,
  requests,
  setuptools,
  urwid,
  watchdog,
}:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.26-dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bpython";
    repo = "bpython";
    tag = version;
    hash = "sha256-HvPdCi2GO6YiV5igH3gRV5it2kdU4+YQMN78S1Xaw7c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version = "unknown"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    curtsies
    cwcwidth
    greenlet
    pygments
    pyxdg
    requests
  ];

  optional-dependencies = {
    clipboard = [ pyperclip ];
    jedi = [ jedi ];
    urwid = [ urwid ];
    watch = [ watchdog ];
  };

  postInstall = ''
    substituteInPlace "$out/share/applications/org.bpython-interpreter.bpython.desktop" \
      --replace "Exec=/usr/bin/bpython" "Exec=bpython"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "bpython" ];

  meta = with lib; {
    changelog = "https://github.com/bpython/bpython/blob/${src.tag}/CHANGELOG.rst";
    description = "Fancy curses interface to the Python interactive interpreter";
    homepage = "https://bpython-interpreter.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      flokli
      dotlambda
    ];
  };
}
