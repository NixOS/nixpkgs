{ stdenv, fetchurl, writeText, nss, python3
, blacklist ? []
, includeEmail ? false
}:

with stdenv.lib;

let

  certdata2pem = fetchurl {
    name = "certdata2pem.py";
    url = "https://anonscm.debian.org/cgit/collab-maint/ca-certificates.git/plain/mozilla/certdata2pem.py?h=debian/20160104";
    sha256 = "0bw11mgfrf19qziyvdnq22kirp0nn54lfsanrg5h6djs6ig1c2im";
  };

in

stdenv.mkDerivation rec {
  name = "nss-cacert-${nss.version}";

  src = nss.src;

  nativeBuildInputs = [ python3 ];

  configurePhase = ''
    ln -s nss/lib/ckfw/builtins/certdata.txt

    cat << EOF > blacklist.txt
    ${concatStringsSep "\n" (map (c: ''"${c}"'') blacklist)}
    EOF

    cp ${certdata2pem} certdata2pem.py
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
  '';

  meta = {
    homepage = http://curl.haxx.se/docs/caextract.html;
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
