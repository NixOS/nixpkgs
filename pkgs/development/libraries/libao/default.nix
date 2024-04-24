{ stdenv, lib, fetchFromGitHub, fetchpatch
, autoreconfHook, pkg-config, libpulseaudio, alsa-lib, libcap
, CoreAudio, CoreServices, AudioUnit
, usePulseAudio }:

stdenv.mkDerivation rec {
  version = "1.2.2";
  pname = "libao";

  # the github mirror is more up to date than downloads.xiph.org
  src = fetchFromGitHub {
    owner  = "xiph";
    repo   = "libao";
    rev    = version;
    sha256 = "0svgk4sc9kdhcsfyvbvgm5vpbg3sfr6z5rliflrw49v3x2i4vxq5";
  };

  patches = [
    # add header time.h for nanosecond
    (fetchpatch {
      name = "nanosecond-header.patch";
      url = "https://github.com/xiph/libao/commit/1f998f5d6d77674dad01b181811638578ad68242.patch";
      hash = "sha256-cvlyhQq1YS4pVya44LfsKD1R6iSOONsHJGRbP5LlanQ=";
    })
  ];

  configureFlags = [
    "--disable-broken-oss"
    "--enable-alsa-mmap"
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  buildInputs = [ ] ++
    lib.optional  usePulseAudio   libpulseaudio ++
    lib.optionals stdenv.isLinux  [ alsa-lib libcap ] ++
    lib.optionals stdenv.isDarwin [ CoreAudio CoreServices AudioUnit ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    longDescription = ''
      Libao is Xiph.org's cross-platform audio library that allows
      programs to output audio using a simple API on a wide variety of
      platforms.
    '';
    homepage = "https://xiph.org/ao/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
