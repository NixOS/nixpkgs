{ stdenv, fetchgit
, cmake
, qt54
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "liblxqt-mount";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "1c8422bd78dfb06b631568b1780ec5f59682cbdc";
    sha256 = "7214227f9410b33044f15debe4202f87795dd39b27c7fa328c0780c9a79f2a96";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools liblxqt ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to manage removable devices";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
