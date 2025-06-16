{
  cmake,
  fetchFromGitLab,
  mediastreamer,
  openh264,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "msopenh264";
  version = "linphone-5.2.6";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "041b07a81f88f1dde2ebb7a1ea0b0e2ec281ab20";
    sha256 = "sha256-IRdHDlcmiZp/FhuAg7pnY/pnuVaZzGB20zMO1kpHjkM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mediastreamer
    openh264
  ];

  # Do not build static libraries
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_INSTALL_RPATH=ON"
  ];

  # CMAKE_INSTALL_PREFIX has no effect so let's install manually. See:
  # https://gitlab.linphone.org/BC/public/msopenh264/issues/1
  installPhase = ''
    mkdir -p $out/lib/mediastreamer/plugins
    cp lib/mediastreamer2/plugins/libmsopenh264.so $out/lib/mediastreamer/plugins/
  '';

  meta = with lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2. Part of the Linphone project";
    homepage = "https://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
