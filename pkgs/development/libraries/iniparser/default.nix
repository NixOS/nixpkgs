{ stdenv, fetchurl }:

stdenv.mkDerivation rec{
  name = "iniparser-3.1";

  src = fetchurl {
    url = "${meta.homepage}/iniparser-3.1.tar.gz";
    sha256 = "1igmxzcy0s25zcy9vmcw0kd13lh60r0b4qg8lnp1jic33f427pxf";
  };

  patches = ./no-usr.patch;

  buildFlags = "libiniparser.so";

  installPhase = ''
    mkdir -p $out/lib
    cp libiniparser.so.0 $out/lib
    ln -s libiniparser.so.0 $out/lib/libiniparser.so

    mkdir -p $out/include
    cp src/*.h $out/include

    mkdir -p $out/share/doc/${name}
    for i in AUTHORS INSTALL LICENSE README; do
      bzip2 -c -9 $i > $out/share/doc/${name}/$i.bz2;
    done;
    cp -r html $out/share/doc/${name}
  '';

  meta = {
    homepage = http://ndevilla.free.fr/iniparser;
    description = "Free standalone ini file parsing library";
    license = stdenv.lib.licenses.mit;
  };
}
