{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation rec {
  name = "glibc-2.9";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://nixos.org/tarballs/glibc-2.9-20081208.tar.bz2;
    sha256 = "0zhxbgcsl97pf349m0lz8d5ljvvzrcqc23yf08d888xlk4ms8m3h";
  };

  inherit kernelHeaders installLocales;

  inherit (stdenv) is64bit;

  patches = [
    /* Fix for NIXPKGS-79: when doing host name lookups, when
       nsswitch.conf contains a line like

         hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4

       don't return an error when mdns4_minimal can't be found.  This
       is a bug in Glibc: when a service can't be found, NSS should
       continue to the next service unless "UNAVAIL=return" is set.
       ("NOTFOUND=return" refers to the service returning a NOTFOUND
       error, not the service itself not being found.)  The reason is
       that the "status" variable (while initialised to UNAVAIL) is
       outside of the loop that iterates over the services, the
       "files" service sets status to NOTFOUND.  So when the call to
       find "mdns4_minimal" fails, "status" will still be NOTFOUND,
       and it will return instead of continuing to "dns".  Thus, the
       line

         hosts: mdns4_minimal [NOTFOUND=return] dns mdns4

       does work because "status" will contain UNAVAIL after the
       failure to find mdns4_minimal. */
    ./nss-skip-unavail.patch

    /* Make it possible to override the locale-archive in NixOS. */
    ./locale-override.patch
  ];

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags = ''
    --enable-add-ons
    --with-headers=${kernelHeaders}/include
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}
  '';

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library";
  };
}
