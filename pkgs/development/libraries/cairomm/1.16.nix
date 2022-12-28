{ stdenv
, lib
, fetchurl
, boost
, meson
, ninja
, pkg-config
, cairo
, fontconfig
, libsigcxx30
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "cairomm";
  version = "1.16.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${version}.tar.xz";
    sha256 = "amO/mKl92isPVeNNG18/uQnvi3D5uNOCyx/zl459wT8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost # for tests
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  propagatedBuildInputs = [
    cairo
    libsigcxx30
  ];

  mesonFlags = [
    "-Dbuild-tests=true"
    "-Dboost-shared=true"
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  # Tests fail on Darwin, possibly because of sandboxing.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A 2D graphics library with support for multiple output devices";
    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';
    homepage = "https://www.cairographics.org/";
    license = with licenses; [ lgpl2Plus mpl10 ];
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
