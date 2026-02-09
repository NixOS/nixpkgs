{
  lib,
  stdenv,
  fetchurl,

  # build
  meson,
  ninja,
  pkg-config,

  # docs
  sphinx,

  # runtime
  buildPackages,
  ffmpeg-headless,

  # tests
  nixosTests,
}:
let
  ffmpeg-bare =
    (ffmpeg-headless.override {
      # explicitly required
      buildAvcodec = true;
      buildAvformat = true;
      buildAvutil = true;
      withPixelutils = true;

      # don't harm, left at default
      # withBzlib
      # withIconv
      # withLzma
      # withZlib
      # all the build options

      # rest, defaulting to withHeadlessDeps, are disabled
      withAlsa = false;
      withAmf = false;
      withAom = false;
      withAss = false;
      withBluray = false;
      withCudaLLVM = false;
      withCuvid = false;
      withDav1d = false;
      withDrm = false;
      withNvcodec = false;
      withFontconfig = false;
      withFreetype = false;
      withFribidi = false;
      withGmp = false;
      withGnutls = false;
      withHarfbuzz = false;
      withMp3lame = false;
      withOpenapv = false;
      withOpencl = false;
      withOpenjpeg = false;
      withOpenmpt = false;
      withOpus = false;
      withRist = false;
      withSoxr = false;
      withSpeex = false;
      withSrt = false;
      withSsh = false;
      withSvtav1 = false;
      withTheora = false;
      withV4l2 = false;
      withVaapi = false;
      withVidStab = false;
      withVorbis = false;
      withVpx = false;
      withVulkan = false;
      withWebp = false;
      withX264 = false;
      withX265 = false;
      withXml2 = false;
      withXvid = false;
      withZimg = false;
      withZvbi = false;
      withNetwork = false;
      buildFfmpeg = false;
      buildFfprobe = false;
      buildAvdevice = false;
      buildAvfilter = false;
      buildSwresample = false;
      buildSwscale = false;
      withManPages = false;
      withHtmlDoc = false;
      withPodDoc = false;
      withTxtDoc = false;
    })
    # tests do not run anymore in this stripped down version
    .overrideAttrs
      { doCheck = false; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "unpaper";
  version = "7.0.0";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/unpaper-${finalAttrs.version}.tar.xz";
    hash = "sha256-JXX7vybCJxnRy4grWWAsmQDH90cRisEwiD9jQZvkaoA=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    buildPackages.libxslt.bin
    meson
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    ffmpeg-bare
  ];

  passthru.tests = {
    inherit (nixosTests) paperless;
  };

  meta = {
    homepage = "https://www.flameeyes.eu/projects/unpaper";
    changelog = "https://github.com/unpaper/unpaper/blob/unpaper-${finalAttrs.version}/NEWS";
    description = "Post-processing tool for scanned sheets of paper";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "unpaper";
    maintainers = [ lib.maintainers.rycee ];
  };
})
