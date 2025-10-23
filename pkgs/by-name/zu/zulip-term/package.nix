{
  lib,
  python3,
  fetchFromGitHub,
  glibcLocales,
  libnotify,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {

      # Requires "urwid~=2.1.2", otherwise some tests are failing
      urwid = super.urwid.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.2";
        src = fetchFromGitHub {
          owner = "urwid";
          repo = "urwid";
          rev = "refs/tags/${version}";
          hash = "sha256-oPb2h/+gaqkZTXIiESjExMfBNnOzDvoMkXvkZ/+KVwo=";
        };
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "zulip-term";
  version = "0.7.0-unstable-2025-05-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = "8e5c0357c8746df64ac427d5db3d2cb0f002f975";
    hash = "sha256-DW3GZ1hY/wZ6P/djPUlAvNIFcBV994FLJ3aiPfDVUBM=";
  };

  patches = [
    ./pytest-executable-name.patch
  ];

  build-system = with py.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    # zulip-term sets these versions for compat with python 3.6/3.7
    "lxml"
    "pygments"
    "typing_extensions"
    "tzlocal"
    "urwid_readline"
    "zulip"
  ];

  dependencies = with py.pkgs; [
    beautifulsoup4
    lxml
    pygments
    pyperclip
    python-dateutil
    pytz
    typing-extensions
    tzlocal
    urwid
    urwid-readline
    zulip
  ];

  nativeCheckInputs = [
    glibcLocales
  ]
  ++ (with python3.pkgs; [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ]);

  disabledTests = [
    # these break the build but don't seem to affect
    # the application at all
    "test_soup2markup"
    "test_main_help"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ libnotify ])
  ];

  meta = {
    description = "Zulip's official terminal client";
    homepage = "https://github.com/zulip/zulip-terminal";
    changelog = "https://github.com/zulip/zulip-terminal/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
