{
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  docutils,
  jinja2,
  pyaml,
  qubes-core-qrexec,
  qubes-core-qubesdb,
  qubes-core-admin-client,
  qubes-core-libvirt,
  pyinotify,
  toPythonModule,
  killall,
  writeScript,
  coreutils,
  gawk,
  pkgs,
  patsh,
  bash,
  lvm2,
  util-linux,
  substituteAll,
  writeShellScript,
  distutils,
  setuptools,
  fetchpatch,

  qubes-vmm-xen,
  qubes-vmm-pyxen,
  qubes-core-qubesdb-client ? pkgs.qubes-core-qubesdb,
  qubes-core-qubesdb-daemon ? pkgs.qubes-core-qubesdb.daemon,

  # Uses entrypoints to provide usb device type extension.
  # It may make sense to pass it to systemd service PYTHONPATH?
  qubes-app-linux-usb-proxy,
}:

let
  inherit (pkgs) hwdata findutils;

  # Original qubes.GetDate RPC uses qubes-core-admin-client package api, and
  # we want to avoid circular dependency here.
  # This script is short, and easily reproducible in just bash.
  # The only bad thing here is that original supports ClockVM... But they are
  # not used in dom0 anyway.
  getDateRpc = writeShellScript "qubes.GetDate" ''
    if test "$#" -lt 1 || test "$#" -gt 2; then
      echo "wrong number of arguments, must have at most 1" >&2
      exit 1
    fi

    arg="-Iseconds"
    if test "$#" -ge 2 && test "$1" -ne 0; then
      arg="-Ins"
    fi

    env -i date -u $arg
  '';

  version = "4.3.6";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-admin";
    rev = "refs/tags/v${version}";
    hash = "sha256-wOkY0qeUF1VezSGTMzYfoELyed058rmjIDEQonSqKeg=";
  };
in
buildPythonPackage {
  inherit version src;
  pname = "qubes-core-admin";
  format = "custom";

  patches = [
    ./0001-refactor-use-mutable-systemd.patch
    ./0002-fix-broken-qvm-device-symlinks.patch
    (substituteAll {
      # Note that out is substituted using %out%, and the actual
      # substitution is done in postPatch
      src = ./0003-refactor-template-paths.patch;
      env = {
        inherit killall hwdata coreutils;
        qubes_client = qubes-core-admin-client;
        qrexec_dom0 = qubes-core-qrexec.dom0;
        qrexec_util = qubes-core-qrexec.util;
        qrexec_client = qubes-core-qrexec;
        qubesdb_daemon = qubes-core-qubesdb-daemon;
        qubesdb_client = qubes-core-qubesdb-client;
        qubes_vmm_xen = qubes-vmm-xen;
      };
    })
    ./0004-fix-fixup-paths.patch
    ./0005-fix-data_percent-might-be-empty.patch
    ./0006-fix-python-prefix-arg.patch

    # Accepted upstream, remove after package update
    # https://github.com/QubesOS/qubes-core-admin/pull/619
    (fetchpatch {
      name = "bad-field-name";
      url = "https://patch-diff.githubusercontent.com/raw/QubesOS/qubes-core-admin/pull/619.patch";
      hash = "sha256-CiDxk8CdDU6Kv6Wp5QTsgifWLeernvOg4bm6nJt/gjE=";
    })
  ];

  postPatch = ''
    cat linux/aux-tools/startup-misc.sh
    substituteInPlace \
      linux/{aux-tools/startup-misc.sh,systemd/qubes-{core,qmemman}.service,systemd/qubesd.service} \
      qubes/{app.py,storage/file.py} \
      --replace-fail "%out%" "$out"

    substituteInPlace qubes-rpc-policy/generate-admin-policy \
      --replace-fail "#!/usr/bin/python3" "#!/usr/bin/env python3"
    # FIXME: Shouldn't it use build-system/nativeBuildInputs/idk?
    wrapPythonProgramsIn qubes-rpc-policy "${lxml} ${docutils} ${jinja2} ${pyaml}"
  '';

  nativeBuildInputs = [
    patsh
    setuptools
    distutils
  ];

  propagatedBuildInputs = [
    lxml
    docutils
    jinja2
    pyaml
    qubes-core-qrexec
    qubes-core-qubesdb
    qubes-core-admin-client
    qubes-core-libvirt
    qubes-app-linux-usb-proxy
    pyinotify
    qubes-vmm-pyxen

    # For scripts
    bash
    lvm2
    util-linux.bin
    coreutils
  ];

  buildFlags = ["all"];

  dontUsePypaInstall = true;
  postInstall = ''
    mkdir -p $man/share

    # TODO: Move to libexec?
    patsh -f $out/lib/qubes/create-snapshot -s ${builtins.storeDir}
    patsh -f $out/lib/qubes/destroy-snapshot -s ${builtins.storeDir}
    wrapPythonProgramsIn $out/lib/qubes ${qubes-core-admin-client}

    cp ${getDateRpc} $out/etc/qubes-rpc/qubes.GetDate
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "DOCDIR=/share/doc/qubes"
    "RELAXNGPATH=/share/doc/qubes/relaxng"
    "FILESDIR=/share/qubes"
    "UNITDIR=/lib/systemd/system"
    "BACKEND_VMM=xen"
    "PYTHON_PREFIX_ARG=--prefix=."
  ];

  pythonImportsCheck = [ "qubes" ];

  outputs = ["out" "man"];
}
