{ fetchurl, stdenv, texinfo, revision, sha256 }:

stdenv.mkDerivation rec {
  name = "r${toString revision}rs";
  src = fetchurl {
    url = "http://swiss.csail.mit.edu/ftpdir/scm/${name}.txi";
    inherit sha256;
  };

  buildInputs = [ texinfo ];

  # Tell the builder about the name of the report.  
  reportName = name;

  builder = ./builder.sh;

  meta = {
    description = "Revised^${toString revision} Report on the Algorithmic Language Scheme";

    longDescription = ''
      This package contains the GNU Info version of the
      the ${toString revision}th revision of the Report on the
      Algorithmic Language Scheme.
    '';

    homepage = http://swiss.csail.mit.edu/~jaffer/Scheme;

    broken = true;
  };
}
