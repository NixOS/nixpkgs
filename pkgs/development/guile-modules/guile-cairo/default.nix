{ lib, stdenv, fetchurl, pkg-config, guile, guile-lib, cairo, expat }:

stdenv.mkDerivation rec {
  pname = "guile-cairo";
  version = "1.11.2";

  src = fetchurl {
    url = "mirror://savannah/guile-cairo/${pname}-${version}.tar.gz";
    sha256 = "0yx0844p61ljd4d3d63qrawiygiw6ks02fwv2cqx7nav5kfd8ck2";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ guile cairo expat ];
  enableParallelBuilding = true;

  doCheck = false; # Cannot find unit-test module from guile-lib
  checkInputs = [ guile-lib ];

  meta = with lib; {
    description = "Cairo bindings for GNU Guile";
    longDescription = ''
      Guile-Cairo wraps the Cairo graphics library for Guile Scheme.

      Guile-Cairo is complete, wrapping almost all of the Cairo API.  It is API
      stable, providing a firm base on which to do graphics work.  Finally, and
      importantly, it is pleasant to use.  You get a powerful and well
      maintained graphics library with all of the benefits of Scheme: memory
      management, exceptions, macros, and a dynamic programming environment.
    '';
    homepage = "https://www.nongnu.org/guile-cairo/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
