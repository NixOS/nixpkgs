{stdenv, fetchurl, readline, mysql, postgresql, sqlite}:

stdenv.mkDerivation rec {
  name = "opendbx-1.4.4";
  src = fetchurl {
    url = "http://linuxnetworks.de/opendbx/download/${name}.tar.gz";
    sha256 = "1pc70l54kkdakdw8njr2pnbcghq7fn2bnk97wzhac2adwdkjp7vs";
  };

  configurePhase = ''
    export CPPFLAGS="-I${mysql}/include/mysql" 
    export LDFLAGS="-L${mysql}/lib/mysql" 
    ./configure --prefix=$prefix --with-backends="mysql pgsql sqlite3" --disable-dependency-tracking --disable-static
  '';

  buildInputs = [readline mysql postgresql sqlite];
}
