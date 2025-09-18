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
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "bpython";
  version = "0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bpython";
    repo = "bpython";
    tag = "${version}-release";
    hash = "sha256-p5+IQiHNRRazqr+WRdx3Yw+ImG25tdZGLXvMf7woD9w=";
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

  passthru.updateScript = gitUpdater {
    rev-suffix = "-release";
  };

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
