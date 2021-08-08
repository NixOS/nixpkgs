{ stdenv, lib, fetchurl, autoreconfHook, xz, coreutils }:

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

  outputs = [ "out" "dev" "devman" ];

  # Without latex2man, no man pages are installed despite being
  # prebuilt in the source tarball.
  configureFlags = [ "LATEX2MAN=${coreutils}/bin/true" ];

  propagatedBuildInputs = [ xz ];

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  doCheck = false; # fails

  meta = with lib; {
    homepage = "https://www.nongnu.org/libunwind";
    description = "A portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    badPlatforms = [ "riscv32-linux" "riscv64-linux" ];
    license = licenses.mit;
  };
}
