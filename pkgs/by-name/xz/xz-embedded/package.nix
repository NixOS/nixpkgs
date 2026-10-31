{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

# Upstream ships no build system (it's meant to be vendored piecemeal into
# whatever project needs it, e.g. the Linux kernel or QGroundControl); the
# CMake build here is ours, mirroring exactly the subset of files and
# compile definitions QGroundControl itself used to assemble ad hoc.
#
# Upstream also ships no automated test of its own: xz-embedded implements
# only a decoder (see the README), and its userspace/{buftest,bytetest,
# boottest}.c and linux/lib/xz/xz_dec_test.c are all manual tools that
# expect a .xz file, or a loaded kernel module, fed in by hand - not
# self-contained checks. cmake-build.patch adds one: a small .xz stream,
# generated once out of band by the reference xz-utils compressor, embedded
# and decoded through the exact vendored decoder this package compiles,
# then compared byte-for-byte against the known-good plaintext it was
# produced from.
stdenv.mkDerivation (finalAttrs: {
  pname = "xz-embedded";
  version = "2024.12.30";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  # Upstream's own tags are dashed ("v2024-12-30"), but version is kept
  # dot-separated to match what the version-regex below always produces
  # (see the updateScript comment) - reconstruct the dashed tag from it
  # here instead of pinning it separately, so the two can't drift apart.
  src = fetchFromGitHub {
    owner = "tukaani-project";
    repo = "xz-embedded";
    tag = "v${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-0UrEB893EzZrWH2oS5gCe6aIxvhfu7hdPoB5pIZ7Bys=";
  };

  patches = [
    ./cmake-build.patch
  ];

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  # Plain --version-regex-less nix-update treats "v20240322" (one 8-digit
  # run) and "v2024-12-30" (three dash-separated runs) as segment-unequal
  # version strings and picks whichever has the longest individual segment,
  # which silently *downgrades* this package (or, for any future release,
  # could wrongly prefer a stale compact-dated tag over a newer dashed one)
  # - normalize both tag styles to "YYYY.MM.DD" so they always compare
  # correctly regardless of upstream's inconsistent dashing.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9]{4})-?([0-9]{2})-?([0-9]{2})$"
    ];
  };

  meta = {
    description = "Tiny XZ decompressor for embedded use, with no library dependencies";
    homepage = "https://github.com/tukaani-project/xz-embedded";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
