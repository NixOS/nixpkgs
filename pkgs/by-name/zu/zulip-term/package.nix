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
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = "refs/tags/${version}";
    hash = "sha256-ZouUU4p1FSGMxPuzDo5P971R+rDXpBdJn2MqvkJO+Fw=";
  };

  patches = [
    ./pytest-executable-name.patch
  ];

  nativeBuildInputs = with py.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with py.pkgs; [
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
