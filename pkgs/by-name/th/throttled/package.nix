{
  lib,
  stdenv,
  fetchFromGitHub,
  gobject-introspection,
  python3Packages,
  pciutils,
  wrapGAppsNoGuiHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throttled";
  version = "unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "erpalma";
    repo = "throttled";
    rev = "c8ec0470697b81426a6e96f15e0c55d5757afcc8";
    hash = "sha256-Kku6AtwNzyp99GD3PyGhNATPp0tNuQ+lPoTrf/B0gBg=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.wrapPython
    wrapGAppsNoGuiHook
  ];

  pythonPath = with python3Packages; [
    configparser
    dbus-python
    dbus-next
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

  meta = {
    description = "Fix for Intel CPU throttling issues";
    homepage = "https://github.com/erpalma/throttled";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
