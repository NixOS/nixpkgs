{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.14.02";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "1g409sr1kj7v1089s9kv0i4azvddkcwcypnbakfryyi71b3jdz9l";
  };

  nativeBuildInputs = [ perl ];

  doCheck = true;

  checkPhase = ''
    make golden && make test
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
    license = licenses.bsd2;
  };
}
