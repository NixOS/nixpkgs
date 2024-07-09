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
  version = "1.18.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${version}.tar.xz";
    sha256 = "uBJVOU4+qOiqiHJ20ir6iYX8ja72BpLrJAfSMEnwPPs=";
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
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  # Tests fail on Darwin, possibly because of sandboxing.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "C++ bindings for the Cairo vector graphics library";
    homepage = "https://www.cairographics.org/";
    license = with licenses; [ lgpl2Plus mpl10 ];
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
