{ stdenv, nss, curl, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  postPatch = ''
    unpackFile ${curl.src};
  '';

  nativeBuildInputs = [ perl ] ++ (with perlPackages; [ LWP ]);

  buildPhase = ''
    perl curl-*/lib/mk-ca-bundle.pl -d "file://$(pwd)/nss/lib/ckfw/builtins/certdata.txt" ca-bundle.crt
  '';

  installPhase = ''
    mkdir -pv $out
    cp -v ca-bundle.crt $out
  '';

  meta = with stdenv.lib; {
    homepage = http://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
