{ stdenv, buildPythonPackage, fetchurl, libguestfs, qemu }:

buildPythonPackage rec {
  pname = "guestfs";
  version = "1.40.1";

  src = fetchurl {
    url = "http://download.libguestfs.org/python/guestfs-${version}.tar.gz";
    sha256 = "06a4b5xf1rkhnzfvck91n0z9mlkrgy90s9na5a8da2g4p776lhkf";
  };

  propagatedBuildInputs = [ libguestfs qemu ];

  meta = with stdenv.lib; {
    homepage = "http://libguestfs.org/guestfs-python.3.html";
    description = "Use libguestfs from Python";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ grahamc ];
  };
}
