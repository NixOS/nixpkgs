{ stdenv, fetchurl, fetchpatch, xz }:

stdenv.mkDerivation rec {
  name = "libunwind-1.1";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${name}.tar.gz";
    sha256 = "16nhx2pahh9d62mvszc88q226q5lwjankij276fxwrm8wb50zzlx";
  };

  patches = [ ./libunwind-1.1-lzma.patch ./cve-2015-3239.patch
              # https://lists.nongnu.org/archive/html/libunwind-devel/2014-04/msg00000.html
              (fetchpatch {
                url = "https://raw.githubusercontent.com/dropbox/pyston/1b2e676417b0f5f17526ece0ed840aa88c744145/libunwind_patches/0001-Change-the-RBP-validation-heuristic-to-allow-size-0-.patch";
                sha256 = "1a0fsgfxmgd218nscswx7pgyb7rcn2gh6566252xhfvzhgn5i4ha";
              })
            ];

  postPatch = ''
    sed -i -e '/LIBLZMA/s:-lzma:-llzma:' configure
  '';

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ xz ];

  preInstall = ''
    mkdir -p "$out/lib"
    touch "$out/lib/libunwind-generic.so"
  '';

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
