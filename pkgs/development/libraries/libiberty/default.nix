{ stdenv, lib, fetchurl, gcc, staticBuild ? false }:

stdenv.mkDerivation rec {
  name = "libiberty-${gcc.cc.version}";

  inherit (gcc.cc) src;

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  configureFlags = [ "--enable-install-libiberty" ] ++ lib.optional (!staticBuild) "--enable-shared";

  postInstall = lib.optionalString (!staticBuild) ''
    cp pic/libiberty.a $out/lib*/libiberty.a
  '';

  meta = with stdenv.lib; {
    homepage = http://gcc.gnu.org/;
    license = licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
