{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libblake3,
  lzmaSupport ? true,
  xz ? null,
}:

assert lzmaSupport -> xz != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "xdelta";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "jmacd";
    repo = "xdelta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-flIXs6a9vU/x4ElNhYTEaunAIltRTCeVdgU1dPRNPcQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/xdelta3";

  postPatch = ''
    # the template assumes a relative CMAKE_INSTALL_LIBDIR, but nixpkgs passes an absolute one
    substituteInPlace cmake/xdelta3.pc.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals lzmaSupport [ xz ];

  cmakeFlags = [
    (lib.cmakeFeature "XD3_LZMA_MODE" (if lzmaSupport then "on" else "off"))
    # upstream downloads BLAKE3 with FetchContent, which can't work in the sandbox
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BLAKE3" "${libblake3.src}")
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
  ];

  doCheck = true;

  meta = {
    description = "Binary differential compression in VCDIFF (RFC 3284) format";
    longDescription = ''
      xdelta is a command line program for delta encoding, which generates two
      file differences. This is similar to diff and patch, but it is targeted
      for binary files and does not generate human readable output.
    '';
    homepage = "https://jmacd.github.io/xdelta/";
    changelog = "https://github.com/jmacd/xdelta/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "xdelta3";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ samirbgno ];
  };
})
