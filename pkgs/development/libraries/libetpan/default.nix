{ stdenv, lib, fetchFromGitHub
, autoconf, automake, libtool, openssl, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libetpan";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    rev = version;
    sha256 = "0g7an003simfdn7ihg9yjv7hl2czsmjsndjrp39i7cad8icixscn";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  buildInputs = [ openssl ];

  configureScript = "./autogen.sh";

  meta = with lib; {
    description = "Mail Framework for the C Language";
    homepage = "http://www.etpan.org/libetpan.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
