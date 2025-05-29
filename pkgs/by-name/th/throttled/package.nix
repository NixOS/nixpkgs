{
  lib,
  stdenv,
  fetchFromGitHub,
  gobject-introspection,
  python3Packages,
  pciutils,
  wrapGAppsNoGuiHook,
}:

stdenv.mkDerivation rec {
  pname = "throttled";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "erpalma";
    repo = "throttled";
    rev = "v${version}";
    sha256 = "sha256-+3ktDkr5hvOfHcch4+mjgJqcuw24UgWTkJqTyDQumyk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.wrapPython
    wrapGAppsNoGuiHook
  ];

  pythonPath = with python3Packages; [
    configparser
    dbus-python
    pygobject3
  ];

  # The upstream unit both assumes the install location, and tries to run in a virtualenv
  postPatch = ''
    sed -e 's|ExecStart=.*|ExecStart=${placeholder "out"}/bin/throttled.py|' -i systemd/throttled.service

    substituteInPlace throttled.py --replace "'setpci'" "'${pciutils}/bin/setpci'"
  '';

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin throttled.py
    install -D -t $out/bin throttled.py mmio.py
    install -D -m644 -t $out/etc etc/*
    install -D -m644 -t $out/lib/systemd/system systemd/*
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = "wrapPythonPrograms";

  meta = with lib; {
    description = "Fix for Intel CPU throttling issues";
    homepage = "https://github.com/erpalma/throttled";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
