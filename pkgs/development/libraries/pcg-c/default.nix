{ stdenv, fetchzip }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.94";
  name = "pcg-c-${version}";

  src = fetchzip {
    url = "http://www.pcg-random.org/downloads/${name}.zip";
    sha256 = "0smm811xbvs03a5nc2668zd0178wnyri2h023pqffy767bpy1vlv";
  };

  enableParallelBuilding = true;

  patches = [
    ./prefix-variable.patch
    ];

  preInstall = ''
    sed -i s,/usr/local,$out, Makefile
    mkdir -p $out/lib $out/include
  '';

  meta = {
    description = "A family of better random number generators";
    homepage = http://www.pcg-random.org/;
    license = stdenv.lib.licenses.asl20;
    longDescription = ''
      PCG is a family of simple fast space-efficient statistically good
      algorithms for random number generation. Unlike many general-purpose RNGs,
      they are also hard to predict.
    '';
    platforms = platforms.unix;
    maintainers = [ maintainers.linus ];
    repositories.git = git://github.com/imneme/pcg-c.git;
    broken = stdenv.isi686; # https://github.com/imneme/pcg-c/issues/11
  };
}
