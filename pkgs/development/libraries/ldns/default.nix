{ stdenv, fetchurl, fetchpatch, openssl, perl, which, dns-root-data }:

stdenv.mkDerivation rec {
  pname = "ldns";
  version = "1.7.0";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.nlnetlabs.nl/downloads/ldns/${name}.tar.gz";
    sha256 = "1k56jw4hz8njspfxcfw0czf1smg0n48ylia89ziwyx5k9wdmp7y1";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-1000231.patch";
      url = "https://git.nlnetlabs.nl/ldns/patch/?id=c8391790";
      sha256 = "1rprfh0y1c28dqiy3vgwvwdhn7b5rsylfzzblx5xdhwfqgdw8vn0";
      excludes = [ "Changelog" ];
    })
    (fetchpatch {
      name = "CVE-2017-1000232.patch";
      url = "https://git.nlnetlabs.nl/ldns/patch/?id=3bdeed02";
      sha256 = "0bv0s5jjp0sswfg8da47d346iwp9yjhj9w7fa3bxh174br0zj07r";
      excludes = [ "Changelog" ];
    })
  ];

  postPatch = ''
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
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  checkInputs = [ which ];
  doCheck = false; # fails. missing some files

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
