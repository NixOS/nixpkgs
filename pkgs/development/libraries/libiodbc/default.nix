{ stdenv, fetchurl, pkgconfig, gtk, useGTK ? false }:

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.7";

  src = fetchurl {
    url = "${meta.homepage}/downloads/iODBC/${name}.tar.gz";
    sha256 = "d7002cc7e566785f1203f6096dcb49b0aad02a9d9946a8eca5d663ac1a85c0c7";
  };

  buildInputs = stdenv.lib.optionals useGTK [ gtk pkgconfig ];

  meta = {
    description = "iODBC driver manager";
    homepage = http://www.iodbc.org;
  };
}
