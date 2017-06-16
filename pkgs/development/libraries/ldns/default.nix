{stdenv, fetchurl, openssl, perl}:

stdenv.mkDerivation rec {
  pname = "ldns";
  version = "1.7.0";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/ldns/${name}.tar.gz";
    sha1 = "ceeeccf8a27e61a854762737f6ee02f44662c1b8";
  };

  patchPhase = ''
    patchShebangs doc/doxyparse.pl
  '';

  outputs = [ "out" "dev" "man" "examples" ];

  nativeBuildInputs = [ perl ];
  buildInputs = [ openssl ];

  configureFlags = [ "--with-ssl=${openssl.dev}" "--with-drill"];

  postInstall = ''
    moveToOutput "bin/ldns-config" "$dev"

    pushd examples
    configureFlagsArray+=( "--bindir=$examples/bin" )
    configurePhase
    make
    make install
    popd
  '';

  meta = with stdenv.lib; {
    description = "Library with the aim of simplifying DNS programming in C";
    license = licenses.bsd3;
    homepage = "http://www.nlnetlabs.nl/projects/ldns/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
