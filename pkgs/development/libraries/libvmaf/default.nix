{ stdenv, fetchFromGitHub, autoconf, automake, intltool, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256="10kgcdf06hzhbl5r7zsllq88bxbyn282hfqx5i3hkp66fpq896d2";
  };

  nativeBuildInputs = [ autoconf automake intltool libtool pkgconfig ];
  outputs = [ "out" "dev" ];
  doCheck = true;

  postFixup = ''
    substituteInPlace "$dev/lib/pkgconfig/libvmaf.pc" \
      --replace "includedir=/usr/local/include" "includedir=$dev"
  '';

  makeFlags = [ "INSTALL_PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.cfsmp3 ];
  };

}
