{ stdenv, fetchgit
, cmake
, qt48

# lxqt dependencies
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "liblxqt-mount";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "8f6d850989e7e7380a2a61ca72e9df148f43e738";
    sha256 = "a0d27a41b84f1805a84fd97d38ab8bf66e4794fecbb467197a69771d9c1e6c01";
  };

  buildInputs = [ stdenv cmake qt48 liblxqt ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to manage removable devices";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
