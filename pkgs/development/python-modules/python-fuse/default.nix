{ lib
, pkgconfig
, fetchurl
, fuse
, buildPythonPackage
, isPy3k
}:

buildPythonPackage rec {
    baseName = "fuse";
    version = "0.2.1";
    name = "${baseName}-${version}";
    disabled = isPy3k;

    src = fetchurl {
      url = "mirror://sourceforge/fuse/fuse-python-${version}.tar.gz";
      sha256 = "06rmp1ap6flh64m81j0n3a357ij2vj9zwcvvw0p31y6hz1id9shi";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ fuse ];

    meta = {
      description = "Python bindings for FUSE";
      license = lib.licenses.lgpl21;
    };
}
