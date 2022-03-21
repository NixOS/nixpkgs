{ stdenv, lib, fetchurl, autoreconfHook, xz, buildPackages }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${pname}-${version}.tar.gz";
    sha256 = "sha256-SmrsZmmR+0XQiJxErt6K1usQgHHDVU/N/2cfnJR5SXY=";
  };

  postPatch = if stdenv.cc.isClang then ''
    substituteInPlace configure.ac --replace "-lgcc_s" ""
  '' else lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace configure.ac --replace "-lgcc_s" "-lgcc_eh"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "devman" ];

  # Without latex2man, no man pages are installed despite being
  # prebuilt in the source tarball.
  configureFlags = [ "LATEX2MAN=${buildPackages.coreutils}/bin/true" ];

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
    badPlatforms = [ "riscv32-linux" ];
    license = licenses.mit;
  };
}
