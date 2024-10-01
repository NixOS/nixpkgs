{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  qubes-core-vchan-xen,
  pkg-config,
  pandoc,
  pyinotify,
  python,
  pygobject3,
  wrapPython,
  gtk3,
  wrapGAppsHook3,
  gobject-introspection,
  gbulb,
  patsh,
  bash,
  socat,
  kmod,
  setuptools,
  distutils,
}:

let
  inherit (lib) optionalString;

  version = "4.2.22";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-qrexec";
    rev = "refs/tags/v${version}";
    hash = "sha256-GxT2KpxIOeRF9j9Lc9SRHqM2G58juFtTd/lXoEJzIyY=";
  };
  makeFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" "INCLUDEDIR=/include" "PYTHON_PREFIX_ARG=--prefix=." ];

  base = buildPythonPackage {
    inherit version src;
    pname = "qubes-core-qrexec-base";
    format = "custom";

    postPatch = ''
      substituteInPlace qrexec/client.py \
        --replace-fail "/usr/bin/qrexec-client-vm" "${domU}/bin/qrexec-client-vm" \
        --replace-fail "/usr/bin/qrexec-client" "${dom0-bootstrap}/lib/qubes/qrexec-client" \
        --replace-fail "/usr/lib/qubes/qubes-rpc-multiplexer" "${util}/libexec/qubes-rpc-multiplexer"
      substituteInPlace policy-agent-extra/qrexec-policy-agent.desktop \
        --replace-fail "Exec=/usr/lib/qubes/qrexec-policy-agent-autostart" "Exec=$out/lib/qubes/qrexec-policy-agent-autostart"
    '';

    nativeBuildInputs = [
      pkg-config
      setuptools
      distutils
      gobject-introspection
      wrapGAppsHook3
    ];

    buildInputs = [
      qubes-core-vchan-xen
      util
      gtk3
    ];

    propagatedBuildInputs = [
      pyinotify
      pygobject3
      gbulb
      qubes-core-vchan-xen
    ];

    buildFlags = ["all-base"];

    dontUsePypaInstall = true;
    installTargets = ["install-base"];

    postInstall = ''
      mv $out/usr/bin $out/
      mv $out/usr/lib/* $out/lib/
      rm -d $out/usr/{lib,}
    '';

    pythonImportsCheck = [ "qrexec" ];

    inherit makeFlags;
  };

  # qrexec-client-vm qrexec-fork-server
  domU = stdenv.mkDerivation {
    inherit version src;
    pname = "qubes-core-qrexec-domU";

    postPatch = ''
      substituteInPlace systemd/qubes-qrexec-agent.service \
        --replace-fail "ExecStart=/usr/lib/" "ExecStart=$out/lib/" \
        --replace-fail "modprobe" "${kmod}/bin/modprobe"
    '';

    nativeBuildInputs = [
      pkg-config
      pandoc
    ];

    buildInputs = [
      qubes-core-vchan-xen
      util
    ];

    buildFlags = ["all-vm"];

    installTargets = ["install-vm"];

    postInstall = ''
      mv $out/usr/{bin,share} $out/
      mv $out/usr/lib/* $out/lib/
      rm -d $out/usr/{lib,}
    '';

    inherit makeFlags;
  };

  dom0 = dom0-core false;
  dom0-bootstrap = dom0-core true;
  # base depends on boostrap, thus building core 2 times:
  # one time it is just the binary usable by base, second time it depends
  # on base and provides everything.
  dom0-core = isBootstrap: stdenv.mkDerivation {
    inherit version src;
    pname = "qubes-core-qrexec-daemon${optionalString isBootstrap "-core"}";

    patches = [
      ./0002-refactor-remove-default-policy-prgram.patch
    ];

    postPatch = optionalString (!isBootstrap) ''
      substituteInPlace systemd/qubes-qrexec-policy-daemon.service \
        --replace-fail "ExecStart=/usr/bin/qrexec-policy-daemon" "ExecStart=${base}/bin/qrexec-policy-daemon"
    '';

    nativeBuildInputs = [
      pkg-config
      patsh
      wrapPython
    ];

    buildInputs = [
      qubes-core-vchan-xen
      util
      bash
      socat
    ];

    buildFlags = ["all-dom0"];

    installTargets = ["install-dom0"];

    postInstall = ''
      mkdir $out/libexec
      mv $out/usr/sbin/* $out/libexec
      mv $out/usr/bin $out/
      mv $out/usr/lib/qubes $out/lib/
      rm -d $out/usr/{lib,sbin,}
    '' + optionalString isBootstrap ''
      # This service is using binary from base package
      rm $out/lib/systemd/system/qubes-qrexec-policy-daemon.service
      # rpc services depend on base
      rm -rf $out/etc/qubes/policy.d
      rm -rf $out/etc/qubes-rpc
      rm -d $out/{etc/{qubes,},lib/systemd/{system,}}
    '' + optionalString (!isBootstrap) ''
      for rpcname in policy.List policy.Get policy.Replace policy.Remove \
        policy.include.List policy.include.Get policy.include.Replace \
        policy.include.Remove policy.GetFiles;
      do
        ln -sf ${base}/bin/qubes-policy-admin $out/etc/qubes-rpc/$rpcname
      done
      patsh -f $out/etc/qubes-rpc/qubes.WaitForSession -s ${builtins.storeDir}
      wrapPythonProgramsIn $out/etc/qubes-rpc ${base}
    '';

    inherit makeFlags;
  };

  # Util hardcodes agent paths, but it is used by agent.
  # Building separate package for agent, which doesn't use those paths.
  util = stdenv.mkDerivation {
    inherit version src;
    pname = "qubes-core-qrexec-util";
    sourceRoot = "${src.name}/libqrexec";

    patches = [
      ./0001-refactor-remove-dependency-of-util-on-daemon.patch
    ];

    postPatch = ''
      # rpc-multiplexer is included in both util and base packages to fix dependency cycle.
      substituteInPlace qrexec.h \
        --replace-fail "/usr/lib/qubes/qubes-rpc-multiplexer" "$out/libexec/qubes-rpc-multiplexer"
    '';

    postInstall = ''
      mkdir -p $out/libexec
      cp ../lib/qubes-rpc-multiplexer $out/libexec/
    '';

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      qubes-core-vchan-xen
    ];

    inherit makeFlags;
  };

  # Both python client library, and commands, needs to be split to module and application.
  client = buildPythonPackage {
    inherit version src;
    pname = "qubes-core-qrexec";
    format = "custom";

    patchPhase = ''
    '';

    nativeBuildInputs = [
      gobject-introspection
      wrapGAppsHook3
      patsh
    ];

    buildInputs = [
      gtk3
    ];

    propagatedBuildInputs = [
      pyinotify
      pygobject3
      gbulb
      qubes-core-vchan-xen

      # For scripts
      bash
      socat
    ];

    postInstall = ''
      mv $out/${python.sitePackages}/usr/bin $out/bin
      wrapGApp $out/bin/qrexec-policy-agent

      mkdir $out/lib/qubes
      cp lib/qrexec-policy-agent-autostart $out/lib/qubes/

      mkdir -p $out/etc/qubes/
      cp -r policy.d $out/etc/qubes/

      mkdir -p $out/etc/qubes-rpc
      ln -sf /var/run/qubes/policy-agent.sock $out/etc/qubes-rpc/policy.Ask
      ln -sf /var/run/qubes/policy-agent.sock $out/etc/qubes-rpc/policy.Notify
      # policy.RegisterArgument depends on qrexec client python api, and can't be moved to qrexec.dom0 package.
      cp qubes-rpc-dom0/* $out/etc/qubes-rpc/

      patsh -f $out/etc/qubes-rpc/qubes.WaitForSession -s ${builtins.storeDir}
      wrapPythonProgramsIn $out/etc/qubes-rpc $out

      install -d $out/etc/xdg/autostart -m 755
    '';

    pythonImportsCheck = [ "qrexec" ];
  };
in
base.overrideAttrs (oldAttrs: {
  passthru = oldAttrs.passthru // {
    inherit domU dom0 dom0-bootstrap util;
  };
})
