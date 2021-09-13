{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, twisted, cython, openssl
, ffmpeg, sqlite, libv4l, libopus, alsa-lib, opencore-amr, pkg-config
, python3-application, python3-eventlib, python3-gnutls, python3-otr
, python3-msrplib, python3-xcaplib, python-dateutil, dnspython, gevent, lxml, x264
, libvpx, iana-etc, libredirect }:
let
  pjsip-src = fetchFromGitHub {
    owner = "pjsip";
    repo = "pjproject";
    rev = "2.10";
    sha256 = "sha256-4BOHrlCqLsjydRv1Ck91FcFSWWklDjDRKQgx/i6LdKo=";
  };
  zrtpcpp-src = fetchFromGitHub {
    owner = "wernerd";
    repo = "ZRTPCPP";
    rev = "6b3cd8e6783642292bad0c21e3e5e5ce45ff3e03";
    sha256 = "sha256-kJlGPVA+yfn7fuRjXU0p234VcZBAf1MU4gRKuPotfog=";
  };
in buildPythonPackage rec {
  pname = "python3-sipsimple";
  version = "5.2.6";

  disabled = !isPy3k;

  src =
    fetchFromGitHub {
      name = pname;
      owner = "AGProjects";
      repo = "python3-sipsimple";
      rev = version;
      sha256 = "sha256-eDCJHb4RphsykDpt5rCjz/GijfhbBLMLwRUhD4hRc5I=";
    };

  prePatch = ''
    pushd deps
    cp -r ${pjsip-src} ./pjproject-${pjsip-src.rev} --no-preserve mode
    cp -r ./pjproject-${pjsip-src.rev} ./pjsip

    mkdir ./pjsip/third_party/zsrtp
    cp -r zsrtp/include ./pjsip/third_party/zsrtp/
    cp -r zsrtp/srtp    ./pjsip/third_party/zsrtp/
    cp -r zsrtp/build   ./pjsip/third_party/build/zsrtp

    cp -r ${zrtpcpp-src} ./ZRTPCPP --no-preserve mode
    mkdir ./pjsip/third_party/zsrtp/zrtp
    cp -r ZRTPCPP/bnlib \
          ZRTPCPP/common \
          ZRTPCPP/cryptcommon \
          ZRTPCPP/srtp \
          ZRTPCPP/zrtp \
          ZRTPCPP/COPYING \
          ZRTPCPP/README.md ./pjsip/third_party/zsrtp/zrtp/
  '';

  patches = [
    "${src}/deps/patches/001_pjsip_210.patch"
    "${src}/deps/patches/002_zsrtp.patch"
    "${src}/deps/patches/003_pjsip_tls_log_fix.patch"
    "${src}/deps/patches/003_vpx.patch"
    "${src}/deps/patches/004_mac_audio_device_fix.patch"
  ];

  patchFlags = "-p0";

  postPatch = ''
    popd
  '';

  preConfigure = ''
    chmod +x deps/pjsip/*configure
    export LD=$CC
  '';

  propagatedBuildInputs = [
    python-dateutil
    dnspython
    gevent
    lxml
    python3-application
    python3-eventlib
    python3-gnutls
    python3-msrplib
    python3-otr
    python3-xcaplib
    twisted
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    openssl
    ffmpeg
    sqlite
    libv4l
    libopus
    alsa-lib
    opencore-amr
    x264
    libvpx
  ];

  # because a test refers to /etc/protocols
  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  pythonImportsCheck = [ "sipsimple" ];

  meta = with lib; {
    description = "Python SDK for development of SIP end-points";
    homepage = "https://github.com/AGProjects/python3-sipsimple";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      SIP SIMPLE client SDK is a Software Development Kit for easy development
      of SIP end-points that support rich media like Audio, Video, Instant Messaging,
      File Transfers, Desktop Sharing and Presence.  Other media types can be
      easily added by using an extensible high-level API.

      The software has undergone in the past years several interoperability tests
      at SIPIT (http://www.sipit.net) and today is of industry strength quality.
    '';
  };
}
