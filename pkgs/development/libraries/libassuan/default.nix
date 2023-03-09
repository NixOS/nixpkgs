{ fetchurl, lib, stdenv, gettext, npth, libgpg-error, buildPackages }:

stdenv.mkDerivation rec {
  pname = "libassuan";
  version = "2.5.5";

  src = fetchurl {
    url = "mirror://gnupg/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-jowvzJgvnKZ9y7HZXi3HRrFzmkZovCCzo8W+Yy7bNOQ=";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # libassuan-config

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ npth gettext ];

  configureFlags = [
    # Required for cross-compilation.
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
  ];

  doCheck = true;

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpg-error.dev}/include/gpg-error.h",g' $dev/include/assuan.h
  '';

  meta = with lib; {
    description = "IPC library used by GnuPG and related software";
    longDescription = ''
      Libassuan is a small library implementing the so-called Assuan
      protocol.  This protocol is used for IPC between most newer
      GnuPG components.  Both, server and client side functions are
      provided.
    '';
    homepage = "http://gnupg.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.erictapen ];
  };
}
