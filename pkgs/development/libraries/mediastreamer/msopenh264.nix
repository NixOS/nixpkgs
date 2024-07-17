{
  autoreconfHook,
  cmake,
  fetchFromGitLab,
  fetchpatch,
  mediastreamer,
  openh264,
  pkg-config,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "msopenh264";
  version = "linphone-4.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "5603a432be2ed10f5d5a5ce068ef83ab2a996d6b";
    sha256 = "sha256-AqZ7tsNZw2Djgyo1JBJbT/c3eQVyEn6r3CT6DQLD/B8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mediastreamer
    openh264
  ];

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
    description = "H.264 encoder/decoder plugin for mediastreamer2. Part of the Linphone project.";
    homepage = "https://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
