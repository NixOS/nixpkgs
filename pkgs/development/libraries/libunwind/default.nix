{ stdenv, lib, fetchurl, autoreconfHook, xz }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${pname}-${version}.tar.gz";
    sha256 = "0dc46flppifrv2z0mrdqi60165ghxm1wk0g47vcbyzjdplqwjnfz";
  };

  patches = [ ./backtrace-only-with-glibc.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace configure.ac --replace "-lgcc_s" "-lgcc_eh"
  '';

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
    homepage = "https://www.nongnu.org/libunwind";
    description = "A portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

  passthru.supportsHost = !stdenv.hostPlatform.isRiscV;
}
