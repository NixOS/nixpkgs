{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, wayland, mesa_noglu, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap
}:

let pname = "wlroots";
    version = "unstable-2017-10-31";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = "7200d643363e988edf6777c38e7f8fcd451a2c50";
    sha256 = "179raymkni1xzaph32zdhg7nfin0xfzrlnbnxkcr266k9y8k66ac";
  };

  # TODO: Temporary workaround for compilation errors
  patches = [ ./libdrm.patch ./no-werror.patch ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland mesa_noglu wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap
  ];

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
