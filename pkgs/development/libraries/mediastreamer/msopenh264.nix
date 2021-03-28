{ autoreconfHook
, cmake
, fetchFromGitLab
, fetchpatch
, mediastreamer
, openh264
, pkg-config
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "msopenh264";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-03-03";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "2c3abf52824ad23a4caae7565ef158ef91767704";
    sha256 = "140hs5lzpshzswvl39klcypankq3v2qck41696j22my7s4wsa0hr";
  };

  nativeBuildInputs = [ autoreconfHook cmake pkg-config ];
  buildInputs = [ mediastreamer openh264 ];

  # Do not build static libraries
  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DCMAKE_SKIP_INSTALL_RPATH=ON"
  ];

  # CMAKE_INSTALL_PREFIX has no effect so let's install manually. See:
  # https://gitlab.linphone.org/BC/public/msopenh264/issues/1
  installPhase = ''
    mkdir -p $out/lib/mediastreamer/plugins
    cp src/libmsopenh264.so $out/lib/mediastreamer/plugins/
  '';

  meta = with lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2";
    homepage = "https://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
