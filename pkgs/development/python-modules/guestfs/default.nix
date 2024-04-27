{ lib, buildPythonPackage, fetchurl, libguestfs, qemu }:

buildPythonPackage rec {
  pname = "guestfs";
  version = "1.40.1";
  format = "setuptools";

  src = fetchurl {
    url = "http://download.libguestfs.org/python/guestfs-${version}.tar.gz";
    sha256 = "06a4b5xf1rkhnzfvck91n0z9mlkrgy90s9na5a8da2g4p776lhkf";
  };

  propagatedBuildInputs = [ libguestfs qemu ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "guestfs" ];

  meta = with lib; {
    homepage = "https://libguestfs.org/guestfs-python.3.html";
    description = "Use libguestfs from Python";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ grahamc ];
    inherit (libguestfs.meta) platforms;
  };
}
