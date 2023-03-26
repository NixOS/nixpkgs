{ lib, stdenv, libgcrypt, curl, gnutls, pkg-config, libiconv, libintl, version, src, meta ? {}, fetchpatch }:

let
  meta_ = meta;
in

stdenv.mkDerivation rec {
  pname = "libmicrohttpd";
  inherit version src;

  patches = lib.optionals (lib.versionOlder version "0.9.76") [
    (fetchpatch {
      name = "CVE-2023-27371.patch";
      url = "https://git.gnunet.org/libmicrohttpd.git/patch/?id=e0754d1638c602382384f1eface30854b1defeec";
      hash = "sha256-vzrq9HPysGpc13rFEk6zLPgpUqp/ST4q/Wp30Dam97k=";
      excludes = [
        "ChangeLog"
      ];
    })
  ];

  outputs = [ "out" "dev" "devdoc" "info" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgcrypt curl gnutls libiconv libintl ];

  preCheck = ''
    # Since `localhost' can't be resolved in a chroot, work around it.
    sed -ie 's/localhost/127.0.0.1/g' src/test*/*.[ch]
  '';

  # Disabled because the tests can time-out.
  doCheck = false;

  meta = with lib; {
    description = "Embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = licenses.lgpl2Plus;

    homepage = "https://www.gnu.org/software/libmicrohttpd/";

    maintainers = with maintainers; [ eelco vrthra fpletz ];
    platforms = platforms.unix;
  } // meta_;
}
