{ stdenv, buildPackages, staticBuild ? false }:

let inherit (buildPackages.buildPackages) gcc; in

stdenv.mkDerivation rec {
  name = "libiberty-${gcc.cc.version}";

  inherit (gcc.cc) src;

  outputs = [ "out" "dev" ];

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  configureFlags = [ "--enable-install-libiberty" ]
    ++ stdenv.lib.optional (!staticBuild) "--enable-shared";

  postInstall = stdenv.lib.optionalString (!staticBuild) ''
    cp pic/libiberty.a $out/lib*/libiberty.a
  '';

  meta = with stdenv.lib; {
    homepage = https://gcc.gnu.org/;
    license = licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = with maintainers; [ abbradar ericson2314 ];
    platforms = platforms.unix;
  };
}
