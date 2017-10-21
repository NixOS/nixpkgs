{stdenv, fetchurl, openssl, perl, dns-root-data}:

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

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-trust-anchor=${dns-root-data}/root.key"
    "--with-drill"
    "--disable-gost"
  ];

  postInstall = ''
    moveToOutput "bin/ldns-config" "$dev"

    pushd examples
    configureFlagsArray+=( "--bindir=$examples/bin" )
    configurePhase
    make
    make install
    popd

    sed -i "$out/lib/libldns.la" -e "s,-L${openssl.dev},-L${openssl.out},g"
  '';

  meta = with stdenv.lib; {
    description = "Library with the aim of simplifying DNS programming in C";
    license = licenses.bsd3;
    homepage = http://www.nlnetlabs.nl/projects/ldns/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
