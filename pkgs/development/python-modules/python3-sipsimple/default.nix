{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  nix-update-script,
  fetchpatch2,
  cython_3_2,
  setuptools,
  alsa-lib,
  ffmpeg_7,
  libopus,
  libuuid,
  libv4l,
  libvpx,
  opencore-amr,
  openssl,
  pkg-config,
  sqlite,
  x264,
  python3-application,
}:
let
  applyPatchesWhenAvailable =
    extDep: dir:
    lib.optionalString (extDep ? patches) (
      lib.strings.concatMapStringsSep "\n" (patch: ''
        echo "Applying patch ${patch}"
        patch -p1 -d ${dir} < ${patch}
      '') extDep.patches
    );
in
buildPythonPackage (finalAttrs: {
  pname = "python3-sipsimple";
  version = "5.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-sipsimple";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-VNlIrij9MVVIYClt20+jBjGNSAWcUP87NgEJOGM+/Xo=";
  };

  # TODO: remove on next release
  patches = lib.optionals (lib.compareVersions finalAttrs.version "5.6.3" == -1) [
    (fetchpatch2 {
      name = "make-build-work-without-G729-headers.patch";
      url = "https://github.com/AGProjects/python3-sipsimple/commit/99ffc170136b92c2b6989f1f33ae6b15dc1d44a3.patch?full_index=1";
      hash = "sha256-emfRPQO+g5W6gsrnBNsAQNhCx0Xbep+eFjl1bcAQ9XM=";
    })
  ];

  postPatch = ''
    substituteInPlace get_dependencies.sh \
      --replace-fail 'sudo apt' 'echo Skipping sudo apt'

    sed -i \
      's/__version__ = ".*"/__version__ = "${finalAttrs.version}"/' \
      sipsimple/__info__.py
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=int-conversion"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = [
    cython_3_2
    setuptools
  ];

  buildInputs = [
    alsa-lib
    ffmpeg_7
    libopus
    libuuid
    libv4l
    libvpx
    opencore-amr
    openssl
    sqlite
    x264
  ];

  dependencies = [
    python3-application
  ];

  preConfigure = ''
    ln -s ${finalAttrs.passthru.extDeps.pjsip.src} deps/${finalAttrs.passthru.extDeps.pjsip.version}.tar.gz
    cp -r --no-preserve=all ${finalAttrs.passthru.extDeps.zrtpcpp.src} deps/ZRTPCPP

    bash ./get_dependencies.sh
  ''
  + applyPatchesWhenAvailable finalAttrs.passthru.extDeps.pjsip "deps/pjsip"
  + applyPatchesWhenAvailable finalAttrs.passthru.extDeps.zrtpcpp "deps/ZRTPCPP"
  + ''
    # Fails to link some static libs due to missing -lc DSO. Just use the compiler frontend instead of raw ld.
    substituteInPlace deps/pjsip/build/rules.mak \
      --replace-fail '$(LD)' "$CC"

    # Incompatible pointers (not const)
    substituteInPlace deps/pjsip/pjmedia/src/pjmedia-codec/ffmpeg_vid_codecs.c \
      --replace-fail '&payload,' '(const pj_uint8_t **)&payload,'
  '';

  # no upstream tests exist
  doCheck = false;

  pythonImportsCheck = [ "sipsimple" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        # "--version-regex"
        # "^release-(.*)$"
      ];
    };
    extDeps = {
      pjsip = rec {
        # Hardcoded in get_dependencies.sh, checked at buildtime
        # need tarball specifically for buildscript to detect it
        version = "2.17";
        src = fetchurl {
          url = "https://github.com/pjsip/pjproject/archive/${version}.tar.gz";
          hash = "sha256-Bl/gbAZ4jZfDX1Y3ltWfAM5S/pVYpS17SQoEKpZvrM4=";
        };
      };
      zrtpcpp = rec {
        # Hardcoded in get_dependencies.sh, NOT checked at buildtime
        rev = "6b3cd8e6783642292bad0c21e3e5e5ce45ff3e03";
        src = fetchFromGitHub {
          owner = "wernerd";
          repo = "ZRTPCPP";
          inherit rev;
          hash = "sha256-pGng1Y9N51nGBpiZbn2NTx4t2NGg4qkmbghTscJVhIA=";
          postFetch = ''
            # fix build with gcc15
            sed -e '9i #include <cstdint>' -i $out/zrtp/EmojiBase32.cpp
          '';
        };
      };
    };
  };

  meta = {
    description = "SIP SIMPLE SDK written in Python";
    homepage = "https://sipsimpleclient.org/";
    downloadPage = "https://github.com/AGProjects/python3-sipsimple";
    changelog = "https://github.com/AGProjects/python3-sipsimple/blob/${finalAttrs.src.rev}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
