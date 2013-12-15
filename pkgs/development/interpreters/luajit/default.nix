{ stdenv, fetchurl }:

stdenv.mkDerivation rec{
    version = "2.0.2";
    name = "LuaJIT-${version}";

    src = fetchurl {
        url="http://luajit.org/download/${name}.tar.gz";
        sha256="0f3cykihfdn3gi6na9p0xjd4jnv26z18m441n5vyg42q9abh4ln0";
    };

    patchPhase = ''
      substituteInPlace Makefile \
        --replace ldconfig ${stdenv.glibc}/sbin/ldconfig
    '';

    installPhase = ''
        make install PREFIX=$out
    '';

    meta = {
        description= "Just-in-time compiler and interpreter for lua 5.1.";
        homepage = http://luajit.org;
        license = stdenv.lib.licenses.mit;
    };
}
