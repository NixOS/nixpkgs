{
  lib,
  stdenv,
  fetchFromGitLab,
  wolfssl,
  bionic-translation,
  python3,
  which,
  jdk17,
  zip,
  xz,
  icu,
  zlib,
  libcap,
  expat,
  openssl,
  libbsd,
  lz4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "art-standalone";
  version = "0-unstable-2024-12-01";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "c4fba44a45e319b57801d81ef946ee953ff70b58";
    hash = "sha256-bNtSNmWRDGsl1/AUC0t0xII1DCH3uKJwhtz0b2nW9qw=";
  };

  patches = [ ./add-liblog-dep.patch ];

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    jdk17
    python3
    which
    zip
  ];

  buildInputs = [
    bionic-translation
    expat
    icu
    libbsd
    libcap
    lz4
    openssl
    wolfssl
    xz
    zlib
  ];

  preConfigure = ''
    patchShebangs build/tools/findleaves.py
    patchShebangs art/tools/cpp-define-generator/make_header.py
    patchShebangs art/runtime/interpreter/mterp/gen_mterp.py
    patchShebangs art/tools/generate_operator_out.py
  '';

  makeFlags = [
    "____LIBDIR=lib"
    "____PREFIX=${placeholder "out"}"
    "____INSTALL_ETC=${placeholder "out"}/etc"
  ];

  meta = {
    description = "Art and dependencies with modifications to make it work on Linux";
    homepage = "https://gitlab.com/android_translation_layer/art_standalone";
    # No license specified yet
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
