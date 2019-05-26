{ stdenv, fetchurl, autoreconfHook, xz }:

stdenv.mkDerivation rec {
  name = "libunwind-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${name}.tar.gz";
    sha256 = "1y0l08k6ak1mqbfj6accf9s5686kljwgsl4vcqpxzk5n74wpm6a3";
  };

  patches = [ ./backtrace-only-with-glibc.patch ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ xz ];

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  doCheck = false; # fails

  meta = with stdenv.lib; {
    homepage = https://www.nongnu.org/libunwind;
    description = "A portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

  passthru.supportsHost = !stdenv.hostPlatform.isRiscV;
}
