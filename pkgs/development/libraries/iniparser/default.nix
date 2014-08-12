{ stdenv, fetchurl }:

stdenv.mkDerivation rec{
  name = "iniparser-3.0b";

  src = fetchurl {
    url = "${meta.homepage}/iniparser3.0b.tar.gz";
    sha256 = "09klyddnqlpbgkv4cmh6ww9q5pv6nf1vfmzw4z256p51rnnlqqwa";
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
