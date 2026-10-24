{
  bpftools,
  clang,
  elfutils,
  fetchFromGitLab,
  lib,
  libbpf,
  meson,
  ninja,
  pkg-config,
  python3,
  python3Packages,
  rustPlatform,
  systemd,
  zlib,
}:
rustPlatform.buildRustPackage rec {
  pname = "udev-hid-bpf";
  version = "2.2.0-20251121";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = pname;
    rev = "${version}";
    hash = "sha256-zZy0qjwirKYbNKFPt3SoM9993h6jOzfmg9jet/7vJ6U=";
  };

  cargoHash = "sha256-cf5FLPT581Dy4msM1hdvflN1OHij+sVdZwLHyRRYWw8=";

  nativeBuildInputs = [
    bpftools
    clang
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    elfutils
    libbpf
    systemd.dev
    zlib
  ];

  nativeCheckInputs = with python3Packages; [
    click
    gitpython
    pytest
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;

  # mesonFlags = [
  #   "-Dprefix=$out"
  #   "-Dudev-dir=$out/etc"
  # ];

  patchPhase = ''
    sed -i '1s|.*|#!${python3}/bin/python3|' tools/generate-hwdb.py
    sed -i '266s|libbpf\.so|${libbpf}/lib/libbpf.so|' test/btf.py
  '';

  configurePhase = ''
    meson setup -Dprefix=$out -Dudevdir=$out/etc build
  '';

  buildPhase = ''
    meson compile -C build
  '';

  installPhase = ''
    meson install -C build
  '';

  # Otherwise, clang fails with error: unsupported option '-fzero-call-used-regs=used-gpr' for target 'bpf'
  hardeningDisable = [
    "zerocallusedregs"
  ];

  meta = with lib; {
    description = "An automatic HID-BPF loader based on udev events written in rust";
    homepage = "https://gitlab.freedesktop.org/libevdev/udev-hid-bpf";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ heyzec ];
    platforms = platforms.linux;
  };
}
