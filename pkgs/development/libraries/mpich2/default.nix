{ stdenv, fetchurl, python, perl, gfortran }:

let version = "1.4"; in
stdenv.mkDerivation {
  name = "mpich2-${version}";

  src = fetchurl {
    url = "http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${version}/mpich2-${version}.tar.gz";
    sha256 = "0bvvk4n9g4rmrncrgs9jnkcfh142i65wli5qp1akn9kwab1q80z6";
  };

  configureFlags = "--enable-shared --enable-sharedlib";

  buildInputs = [ python perl gfortran ];
  propagatedBuildInputs = stdenv.lib.optional (stdenv ? glibc) stdenv.glibc;

  patchPhase =
    '' for i in $(find -type f -not -name Makefile.\*)
       do
         if grep -q /usr/bin/env "$i"
         then
             interpreter="$(cat $i | grep /usr/bin/env | sed -'es|^.*/usr/bin/env \([^ ]\+\).*$|\1|g')"
             echo "file \`$i' -> interpreter \`$interpreter'"
             path="$(type -P $interpreter)"
             echo "\`/usr/bin/env $interpreter' -> \`$path' in \`$i'..."
             sed -i "$i" -e "s|/usr/bin/env $interpreter|$path|g"
         fi
       done
       true
    '';

  meta = {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = "free, see http://www.mcs.anl.gov/research/projects/mpich2/downloads/index.php?s=license";

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
