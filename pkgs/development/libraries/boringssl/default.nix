{ stdenv, fetchgit, cmake, perl, go }:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
stdenv.mkDerivation {
  pname = "boringssl";
  version = "2019-12-04";

  src = fetchgit {
    url    = "https://boringssl.googlesource.com/boringssl";
    rev    = "243b5cc9e33979ae2afa79eaa4e4c8d59db161d4";
    sha256 = "1ak27dln0zqy2vj4llqsb99g03sk0sg25wlp09b58cymrh3gccvl";
  };

  nativeBuildInputs = [ cmake perl go ];
  enableParallelBuilding = true;

  makeFlags = [ "GOCACHE=$(TMPDIR)/go-cache" ];

  installPhase = ''
    mkdir -p $bin/bin $out/include $out/lib

    mv tool/bssl $bin/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include/openssl $out/include
  '';

  outputs = [ "out" "bin" ];

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "https://boringssl.googlesource.com";
    platforms   = platforms.all;
    maintainers = [ maintainers.thoughtpolice ];
    license = with licenses; [ openssl isc mit bsd3 ];
  };
}
