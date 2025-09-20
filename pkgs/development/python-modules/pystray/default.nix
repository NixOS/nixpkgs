{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  gobject-introspection,
  setuptools,
  pillow,
  six,
  pygobject3,
  gtk3,
  stdenv,
  xlib,
  libayatana-appindicator,
  pyobjc-framework-Quartz,
  xvfb-run,
  pytest,
}:

buildPythonPackage rec {
  pname = "pystray";
  version = "0.19.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pystray";
    rev = "v${version}";
    hash = "sha256-CZhbaXwKFrRBEomzfFPMQdMkTOl5lbgI64etfDRiRu4=";
  };

  patches = [
    # fix test_menu_construct_from_none test case
    # https://github.com/moses-palmer/pystray/pull/133
    (fetchpatch {
      url = "https://github.com/moses-palmer/pystray/commit/813007e3034d950d93a2f3e5b029611c3c9c98ad.patch";
      hash = "sha256-m2LfZcWXSfgxb73dac21VDdMDVz3evzcCz5QjdnfM1U=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'sphinx >=1.3.1'" ""
  '';

  nativeBuildInputs = [
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    pillow
    six
    pygobject3
    gtk3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xlib
    libayatana-appindicator
  ]
  ++ lib.optionals stdenv.isDarwin [ pyobjc-framework-Quartz ];

  nativeCheckInputs = [ pytest ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ];

  checkPhase = ''
    runHook preCheck

    ${lib.optionalString stdenv.hostPlatform.isLinux "xvfb-run -s '-screen 0 800x600x24' "}pytest tests/menu_descriptor_tests.py

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/moses-palmer/pystray";
    description = "This library allows you to create a system tray icon";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ jojosch ];
  };
}
