{ stdenv, fetchurl, nss, python3
, blacklist ? []
, includeEmail ? false
}:

with stdenv.lib;

let

  certdata2pem = fetchurl {
    name = "certdata2pem.py";
    url = "https://salsa.debian.org/debian/ca-certificates/raw/debian/20170717/mozilla/certdata2pem.py";
    sha256 = "1d4q27j1gss0186a5m8bs5dk786w07ccyq0qi6xmd2zr1a8q16wy";
  };

in

stdenv.mkDerivation {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  outputs = [ "out" "unbundled" ];

  nativeBuildInputs = [ python3 ];

  configurePhase = ''
    ln -s nss/lib/ckfw/builtins/certdata.txt

    cat << EOF > blacklist.txt
    ${concatStringsSep "\n" (map (c: ''"${c}"'') blacklist)}
    EOF

    cat ${certdata2pem} > certdata2pem.py
    patch -p1 < ${./fix-unicode-ca-names.patch}
    ${optionalString includeEmail ''
      # Disable CAs used for mail signing
      substituteInPlace certdata2pem.py --replace \[\'CKA_TRUST_EMAIL_PROTECTION\'\] '''
    ''}
  '';

  buildPhase = ''
    python certdata2pem.py | grep -vE '^(!|UNTRUSTED)'

    for cert in *.crt; do
      echo $cert | cut -d. -f1 | sed -e 's,_, ,g' >> ca-bundle.crt
      cat $cert >> ca-bundle.crt
      echo >> ca-bundle.crt
    done
  '';

  installPhase = ''
    mkdir -pv $out/etc/ssl/certs
    cp -v ca-bundle.crt $out/etc/ssl/certs
    # install individual certs in unbundled output
    mkdir -pv $unbundled/etc/ssl/certs
    cp -v *.crt $unbundled/etc/ssl/certs
    rm -f $unbundled/etc/ssl/certs/ca-bundle.crt  # not wanted in unbundled
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = https://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
