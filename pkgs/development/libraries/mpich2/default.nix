{ stdenv, fetchurl, python, perl }:

let version = "1.2.1"; in
stdenv.mkDerivation {
  name = "mpich2-${version}";

  src = fetchurl {
    url = "http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${version}/mpich2-${version}.tar.gz";
    sha256 = "1h91hygal4h33yci7sw76hibf803r9c0mx7kfgmc06h27xa3cirr";
  };

  buildInputs = [ python perl ];

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
    description = "MPICH2, an implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = "free, see http://www.mcs.anl.gov/research/projects/mpich2/downloads/index.php?s=license";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.unix;
  };
}
