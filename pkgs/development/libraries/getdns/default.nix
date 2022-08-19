# Getdns and Stubby are released together, see https://getdnsapi.net/releases/

{ lib, stdenv, fetchurl, cmake, darwin, doxygen, libidn2, libyaml, openssl
, systemd, unbound, yq }:
let
  metaCommon = with lib; {
    maintainers = with maintainers; [ leenaars ehmry ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
in rec {

  getdns = stdenv.mkDerivation rec {
    pname = "getdns";
    version = "1.7.2";
    outputs = [ "out" "dev" "lib" "man" ];

    src = fetchurl {
      url = "https://getdnsapi.net/releases/${pname}-${
          with builtins;
          concatStringsSep "-" (splitVersion version)
        }/${pname}-${version}.tar.gz";
      sha256 =
        # upstream publishes hashes in hex format
        "db89fd2a940000e03ecf48d0232b4532e5f0602e80b592be406fd57ad76fdd17";
    };

    nativeBuildInputs = [ cmake doxygen ];

    buildInputs = [ libidn2 openssl unbound ];

    postInstall = "rm -r $out/share/doc";

    meta = with lib;
      metaCommon // {
        description = "A modern asynchronous DNS API";
        longDescription = ''
          getdns is an implementation of a modern asynchronous DNS API; the
          specification was originally edited by Paul Hoffman. It is intended to make all
          types of DNS information easily available to application developers and non-DNS
          experts. DNSSEC offers a unique global infrastructure for establishing and
          enhancing cryptographic trust relations. With the development of this API the
          developers intend to offer application developers a modern and flexible
          interface that enables end-to-end trust in the DNS architecture, and which will
          inspire application developers to implement innovative security solutions in
          their applications.
        '';
        homepage = "https://getdnsapi.net";
      };
  };

  stubby = stdenv.mkDerivation rec {
    pname = "stubby";
    version = "0.4.2";
    outputs = [ "out" "man" "stubbyExampleJson" ];

    inherit (getdns) src;
    sourceRoot = "${getdns.name}/stubby";

    nativeBuildInputs = [ cmake doxygen yq ];

    buildInputs = [ getdns libyaml openssl systemd ]
      ++ lib.optionals stdenv.isDarwin [ darwin.Security ];

    postInstall = ''
      rm -r $out/share/doc
      yq \
        < $NIX_BUILD_TOP/$sourceRoot/stubby.yml.example \
        > $stubbyExampleJson
    '';

    passthru.settingsExample = with builtins;
      fromJSON (readFile stubby.stubbyExampleJson);

    meta = with lib;
      metaCommon // {
        description = "A local DNS Privacy stub resolver (using DNS-over-TLS)";
        longDescription = ''
          Stubby is an application that acts as a local DNS Privacy stub
          resolver (using RFC 7858, aka DNS-over-TLS). Stubby encrypts DNS
          queries sent from a client machine (desktop or laptop) to a DNS
          Privacy resolver increasing end user privacy. Stubby is developed by
          the getdns team.
        '';
        homepage = "https://dnsprivacy.org/wiki/x/JYAT";
      };
  };

}
