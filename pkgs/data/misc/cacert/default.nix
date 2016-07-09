{ stdenv, nss, curl, perl }:

stdenv.mkDerivation rec {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  postPatch = ''
    unpackFile ${curl.src};

    # Remove dependency on LWP, curl is enough. Also, since curl here
    # is working on a local file it will not actually get a 200 OK, so
    # remove that expectation.
    substituteInPlace curl-*/lib/mk-ca-bundle.pl \
      --replace 'use LWP::UserAgent;' "" \
      --replace ' && $out[0] == 200' ""
  '';

  nativeBuildInputs = [ curl perl ];

  buildPhase = ''
    perl curl-*/lib/mk-ca-bundle.pl -d "file://$(pwd)/nss/lib/ckfw/builtins/certdata.txt" ca-bundle.crt
  '';

  installPhase = ''
    mkdir -pv $out/etc/ssl/certs
    cp -v ca-bundle.crt $out/etc/ssl/certs
  '';

  meta = with stdenv.lib; {
    homepage = http://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
