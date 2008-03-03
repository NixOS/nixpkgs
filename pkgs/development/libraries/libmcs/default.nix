{stdenv, fetchurl, pkgconfig, libmowgli}:

stdenv.mkDerivation {
  name = "libmcs-0.7.0";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/libmcs-0.7.0.tgz;
    sha256 = "11qjrxxgk0yvqm668dyaj54kgijcnkaid8dld8lf4br2glmz2jy5";
  };

  buildInputs = [pkgconfig libmowgli];
  
  meta = {
    description = "A library and set of userland tools which abstract the storage of configuration settings away from userland applications";
    homepage = http://www.atheme.org/projects/mcs.shtml;
  };
}
