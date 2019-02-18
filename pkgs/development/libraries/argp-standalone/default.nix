{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "argp-standalone-1.3";

  src = fetchurl {
    url = "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz";
    sha256 = "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be";
  };

  patches = [
    (if stdenv.hostPlatform.isDarwin then
    fetchpatch {
      name = "patch-argp-fmtstream.h";
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/b5f0ad3/argp-standalone/patch-argp-fmtstream.h";
      sha256 = "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8";
    }
    else null)
  ];

  patchFlags = "-p0";

  postInstall = 
    ''
      mkdir -p $out/lib $out/include
      cp libargp.a $out/lib
      cp argp.h $out/include
    '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.lysator.liu.se/~nisse/misc/";
    description = "Standalone version of arguments parsing functions from GLIBC";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ amar1729 ];
    license = stdenv.lib.licenses.gpl2;
  };
}
