{stdenv, fetchurl, pkgconfig, libmowgli}:

stdenv.mkDerivation {
  name = "libmcs-0.7.1";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/libmcs-0.7.1.tbz2;
    sha256 = "16ckfdprqyb9jhhnhvyhw2rkwadq1z6l3a00fvix16sjzh8dgcz0";
  };

  buildInputs = [pkgconfig libmowgli];
  
  meta = {
    description = "A library and set of userland tools which abstract the storage of configuration settings away from userland applications";
    homepage = http://www.atheme.org/projects/mcs.shtml;
  };
}
