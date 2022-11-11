{ lib, stdenv, fetchurl, xercesc }:

stdenv.mkDerivation rec {
  pname = "libcutl";
  version = "1.10.0";

  meta = with lib; {
    description = "C++ utility library from Code Synthesis";
    longDescription = ''
        libcutl is a C++ utility library.
        It contains a collection of generic and independent components such as
        meta-programming tests, smart pointers, containers, compiler building blocks, etc.
    '';
    homepage = "https://codesynthesis.com/projects/libcutl/";
    changelog = "https://git.codesynthesis.com/cgit/libcutl/libcutl/plain/NEWS?h=${version}";
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };

  majmin = builtins.head ( builtins.match "([[:digit:]]\\.[[:digit:]]+).*" "${version}" );
  src = fetchurl {
    url = "https://codesynthesis.com/download/${pname}/${majmin}/${pname}-${version}.tar.bz2";
    sha256 = "070j2x02m4gm1fn7gnymrkbdxflgzxwl7m96aryv8wp3f3366l8j";
  };

  buildInputs = [ xercesc ];
  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-std=c++14" ];
}
