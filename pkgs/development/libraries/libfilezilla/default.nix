{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libfilezilla-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/filezilla/libfilezilla/${version}/${name}.tar.bz2";
    sha256 = "07f5hk5izqgqjadrwy608gi0w3scm3zvpsv63j7bgfqk67qilslc";
  };

  meta = with stdenv.lib; {
    homepage = https://lib.filezilla-project.org/;
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
