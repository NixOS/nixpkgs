{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  distutils,
  stdenv,
  patsh,
  pkgs,
  usbguard,
  systemd,
  wrapPython,
}:
let
  inherit (pkgs) qubes-core-qubesdb hwdata;
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-app-linux-usb-proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-i06Q6AcSxDvyjE5zott/+p2fm0cminqeHx5f/Yx+tRU=";
  };

  sys-usb = stdenv.mkDerivation {
    inherit version src;
    pname = "qubes-app-linux-usb-proxy-sys-usb";
    format = "custom";

    nativeBuildInputs = [
      patsh
      wrapPython
    ];

    buildInputs = [
      qubes-core-qubesdb
      usbguard
      systemd # udevadm
    ];

    patchPhase = ''
      substituteInPlace qubes-rpc/qubes.USB{,Attach} \
        --replace-fail "/usr/lib/qubes/" "$out/lib/qubes/"
      substituteInPlace src/usb-export \
        --replace-fail "/usr/lib/qubes/" "$out/lib/qubes/"
    '';

    buildPhase = "true";

    installTargets = ["install-vm"];
    postInstall = ''
      mv $out/usr/* $out/
      rm -d $out/usr

      for script in usb-detach-all usb-export usb-import; do
        patsh -f $out/lib/qubes/$script -s ${builtins.storeDir}
      done
      wrapPythonProgramsIn $out/lib/qubes

      rm $out/etc/qubes/suspend-pre.d/usb-detach-all.sh
      ln -sf $out/lib/qubes/usb-detach-all $out/etc/qubes/suspend-pre.d/usb-detach-all.sh
    '';

    installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  };
in
buildPythonPackage {
  inherit version src;
  pname = "qubes-app-linux-usb-proxy";
  format = "custom";

  patchPhase = ''
    substituteInPlace Makefile \
      --replace-fail "python3 setup.py install" "python3 setup.py install --prefix=."
    substituteInPlace qubesusbproxy/core3ext.py \
      --replace-fail "/usr/share/hwdata" "${hwdata}/share/hwdata"
  '';

  passthru = {
    inherit sys-usb;
  };

  nativeBuildInputs = [
    setuptools
    distutils
  ];

  buildPhase = "python3 setup.py build";

  dontUsePypaInstall = true;
  installTargets = ["install-dom0"];

  makeFlags = [ "DESTDIR=$(out)" ];

  pythonImportsCheck = [ "qubesusbproxy" ];
}
