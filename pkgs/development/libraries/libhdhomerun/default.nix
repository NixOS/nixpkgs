{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "libhdhomerun-1efbcb";

  src = fetchgit {
    url = "git://github.com/Silicondust/libhdhomerun.git";
    rev = "1efbcb2b87b17a82f2b3d873d1c9cc1c6a3a9b77";
    sha256 = "11iyrfs98xb50n9iqnwfphmmnn5w3mq2l9cjjpf8qp29cvs33cgy";
  };

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "gcc" "cc"
    substituteInPlace Makefile --replace "-arch i386" ""
  '';

  installPhase = let
    libSuff = if stdenv.isDarwin then "dylib" else "so";
  in ''
    mkdir -p $out/{bin,lib,include/hdhomerun}
    install -Dm444 libhdhomerun.${libSuff} $out/lib
    install -Dm555 hdhomerun_config $out/bin
    cp *.h $out/include/hdhomerun
  '';

  meta = with stdenv.lib; {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    homepage = https://github.com/Silicondust/libhdhomerun;
    repositories.git = "https://github.com/Silicondust/libhdhomerun.git";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.titanous ];
  };
}
