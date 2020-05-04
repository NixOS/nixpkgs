{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.16";

  src = fetchFromGitHub {
    owner = "besser82";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:1yyn33h9f0w4aahknvpqmzxjxzfhqy6g1d8x6x9wlwbpazx98xx7";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isx86 "--enable-fat=yes";

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modern library for one-way hashing of passwords";
    homepage = "https://github.com/besser82/libxcrypt";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.gpl2;
  };
}
