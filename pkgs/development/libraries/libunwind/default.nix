{ stdenv, fetchurl, fetchpatch, autoreconfHook, xz }:

stdenv.mkDerivation rec {
  name = "libunwind-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${name}.tar.gz";
    sha256 = "1jsslwkilwrsj959dc8b479qildawz67r8m4lzxm7glcwa8cngiz";
  };

  patches = [
    ./version-1.2.1.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ xz ];

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
