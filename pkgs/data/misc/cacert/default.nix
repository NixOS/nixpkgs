{ stdenv, fetchurl, nss, python3
, blacklist ? []

# Used for tests only
, runCommand
, cacert
, openssl
}:

with stdenv.lib;

let

  certdata2pem = fetchurl {
    name = "certdata2pem.py";
    url = "https://salsa.debian.org/debian/ca-certificates/raw/debian/20170717/mozilla/certdata2pem.py";
    sha256 = "1d4q27j1gss0186a5m8bs5dk786w07ccyq0qi6xmd2zr1a8q16wy";
  };

  version = "3.60";
  underscoreVersion = builtins.replaceStrings ["."] ["_"] version;
in

stdenv.mkDerivation {
  name = "nss-cacert-${version}";

  src = fetchurl {
    url = "mirror://mozilla/security/nss/releases/NSS_${underscoreVersion}_RTM/src/nss-${version}.tar.gz";
    sha256 = "hKvVV1q4dMU65RG9Rh5dCGjRobOE7kB1MVTN0dWQ/j0=";
  };

  outputs = [ "out" "unbundled" ];

  nativeBuildInputs = [ python3 ];

  configurePhase = ''
    ln -s nss/lib/ckfw/builtins/certdata.txt

    cat << EOF > blacklist.txt
    ${concatStringsSep "\n" (map (c: ''"${c}"'') blacklist)}
    EOF

    cat ${certdata2pem} > certdata2pem.py
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

  passthru.updateScript = ./update.sh;
  passthru.tests = {
    # Test that building this derivation with a blacklist works, and that UTF-8 is supported.
    blacklist-utf8 = let
      blacklistCAToFingerprint = {
        # "blacklist" uses the CA name from the NSS bundle, but we check for presence using the SHA256 fingerprint.
        "CFCA EV ROOT" = "5C:C3:D7:8E:4E:1D:5E:45:54:7A:04:E6:87:3E:64:F9:0C:F9:53:6D:1C:CC:2E:F8:00:F3:55:C4:C5:FD:70:FD";
        "NetLock Arany (Class Gold) Főtanúsítvány" = "6C:61:DA:C3:A2:DE:F0:31:50:6B:E0:36:D2:A6:FE:40:19:94:FB:D1:3D:F9:C8:D4:66:59:92:74:C4:46:EC:98";
      };
      mapBlacklist = f: concatStringsSep "\n" (mapAttrsToList f blacklistCAToFingerprint);
    in runCommand "verify-the-cacert-filter-output" {
      cacert = cacert.unbundled;
      cacertWithExcludes = (cacert.override {
        blacklist = builtins.attrNames blacklistCAToFingerprint;
      }).unbundled;

      nativeBuildInputs = [ openssl ];
    } ''
      isPresent() {
        # isPresent <unbundled-dir> <ca name> <ca sha256 fingerprint>
        for f in $1/etc/ssl/certs/*.crt; do
          fingerprint="$(openssl x509 -in "$f" -noout -fingerprint -sha256 | cut -f2 -d=)"
          if [[ "x$fingerprint" == "x$3" ]]; then
            return 0
          fi
        done
        return 1
      }

      # Ensure that each certificate is in the main "cacert".
      ${mapBlacklist (caName: caFingerprint: ''
        isPresent "$cacert" "${caName}" "${caFingerprint}" || ({
          echo "CA fingerprint ${caFingerprint} (${caName}) is missing from the CA bundle. Consider picking a different CA for the blacklist test." >&2
          exit 1
        })
      '')}

      # Ensure that each certificate is NOT in the "cacertWithExcludes".
      ${mapBlacklist (caName: caFingerprint: ''
        isPresent "$cacertWithExcludes" "${caName}" "${caFingerprint}" && ({
          echo "CA fingerprint ${caFingerprint} (${caName}) is present in the cacertWithExcludes bundle." >&2
          exit 1
        })
      '')}

      touch $out
    '';
  };

  meta = {
    homepage = "https://curl.haxx.se/docs/caextract.html";
    description = "A bundle of X.509 certificates of public Certificate Authorities (CA)";
    platforms = platforms.all;
    maintainers = with maintainers; [ andir fpletz lukegb ];
    license = licenses.mpl20;
  };
}
