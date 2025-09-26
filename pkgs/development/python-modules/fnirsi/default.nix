{
  lib,
  fetchFromGitHub,
  stdenv,
  buildPythonPackage,
  python3Packages,
}:

buildPythonPackage rec {
  pname = "fnirsi-usb-power-data-logger";
  # https://github.com/baryluk/fnirsi-usb-power-data-logger/pull/26
  version = "unstable-2025-07-01";

  src = fetchFromGitHub {
    owner = "baryluk";
    repo = "fnirsi-usb-power-data-logger";
    rev = "5aaecf514d92fe1ce1bfcc4051ab37c38798d264";
    hash = "sha256-Kiq7sLh5FM6FxVDO/j7cm+nYe4ZwyNjWMHTFr78jo5Q=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyusb
    crc
  ];

  format = "pyproject";

  # Custom install phase if there's no setup.py
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/${python3Packages.python.sitePackages}

    # Copy Python files to site-packages
    cp -r *.py $out/${python3Packages.python.sitePackages}/

    # Create executable scripts
    for script in fnirsi_logger.py; do
      if [ -f $script ]; then
        makeWrapper ${python3Packages.python.interpreter} $out/bin/''${script%.py} \
          --add-flags "$out/${python3Packages.python.sitePackages}/$script" \
          --set PYTHONPATH "$PYTHONPATH:$out/${python3Packages.python.sitePackages}"
      fi
    done
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/etc/udev/rules.d
    cp udev/90-usb-power-meter.rules $out/etc/udev/rules.d
  '';

  nativeBuildInputs = [
    python3Packages.wrapPython
    python3Packages.setuptools
  ];

  meta = {
    description = "USB power data logger for FNIRSI devices";
    homepage = "https://github.com/baryluk/fnirsi-usb-power-data-logger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phodina ];
    platforms = lib.platforms.all;
    mainProgram = "fnirsi_logger";
  };
}
