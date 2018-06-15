{ stdenv, fetchurl, libvdpau, libGLU_combined, libva, pkgconfig }:
let
  libvdpau08patch = (fetchurl { url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/x11-libs/libva-vdpau-driver/files/libva-vdpau-driver-0.7.4-libvdpau-0.8.patch?revision=1.1";
                                name = "libva-vdpau-driver-0.7.4-libvdpau-0.8.patch";
                                sha256 = "1n2cys59wyv8ylx9i5m3s6856mgx24hzcp45w1ahdfbzdv9wrfbl";
                              });
in
stdenv.mkDerivation rec {
  name = "libva-vdpau-driver-0.7.4";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${name}.tar.bz2";
    sha256 = "1fcvgshzyc50yb8qqm6v6wn23ghimay23ci0p8sm8gxcy211jp0m";
  };

  patches = [ ./glext85.patch
              (fetchurl { url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/x11-libs/libva-vdpau-driver/files/libva-vdpau-driver-0.7.4-VAEncH264VUIBufferType.patch?revision=1.1";
                          name = "libva-vdpau-driver-0.7.4-VAEncH264VUIBufferType.patch";
                          sha256 = "166svcav6axkrlb3i4rbf6dkwjnqdf69xw339az1f5yabj72pqqs";
                        }) ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvdpau libGLU_combined libva ];

  preConfigure = ''
    patch -p0 < ${libvdpau08patch}  # use -p0 instead of -p1
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';


  meta = {
    homepage = https://cgit.freedesktop.org/vaapi/vdpau-driver/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "VDPAU driver for the VAAPI library";
    platforms = stdenv.lib.platforms.linux;
  };
}
