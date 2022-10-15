{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, perl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.28";

  src = fetchFromGitHub {
    owner = "besser82";
    repo = "libxcrypt";
    rev = "v${version}";
    sha256 = "sha256-Ohf+RCOXnoCxAFnXXV9e2TCqpfZziQl+FGJTGDSQTF0=";
  };

  patches = [
    # Fix for tests on musl is being upstreamed:
    # https://github.com/besser82/libxcrypt/pull/157
    # Applied in all environments to prevent patchrot
    (fetchpatch {
      url = "https://github.com/besser82/libxcrypt/commit/a4228faa0b96986abc076125cf97d352a063d92f.patch";
      sha256 = "sha256-iGNz8eer6OkA0yR74WisE6GbFTYyXKw7koXl/R7DhVE=";
    })
  ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = [
    "--disable-werror"
  ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config perl ];

  doCheck = true;

  meta = with lib; {
    description = "Extended crypt library for descrypt, md5crypt, bcrypt, and others";
    homepage = "https://github.com/besser82/libxcrypt/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dottedmag ];
    license = licenses.lgpl21Plus;
  };
}
