{ stdenv, fetchurl, gmp, unzip, pkgconfig } :

stdenv.mkDerivation rec {
  pname = "dsharp";
  date = "2013-12-02";
  name = "${pname}-${date}";

  src = fetchurl {
    url = "https://bitbucket.org/haz/dsharp/get/5922bcae9a7f.zip";
    sha256 = "0cfbjah4lsij9v2lp1pbq42wyyzf2y0dmlm75i4yjn7vqp6iq32d";
  };

  buildInputs = [unzip gmp pkgconfig];

  preBuild = ''
    cp Makefile_gmp Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp dsharp $out/bin/
    
    mkdir $out/src/
    cp -r src $out/
  '';

  meta = {
    description = "a CNF to d-DNNF compiler";
    homepage = "http://www.haz.ca/academic.html";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.algorith ];
    platforms = stdenv.lib.platforms.linux;
  };
}
