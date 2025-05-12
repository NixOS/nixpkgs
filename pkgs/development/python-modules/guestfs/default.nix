{
  lib,
  buildPythonPackage,
  fetchurl,
  libguestfs,
  qemu,
}:

buildPythonPackage rec {
  pname = "guestfs";
  version = "1.40.2";
  format = "setuptools";

  src = fetchurl {
    url = "http://download.libguestfs.org/python/guestfs-${version}.tar.gz";
    hash = "sha256-GCKwkhrIXPz0hPrwe3YrhlEr6TuDYQivDzpMlZ+CAzI=";
  };

  propagatedBuildInputs = [
    libguestfs
    qemu
  ];

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
