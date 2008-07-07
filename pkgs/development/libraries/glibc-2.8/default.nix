{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation rec
{
  name = "glibc-2.8-20080707";
  builder = ./builder.sh;
  src = fetchurl
  {
    url = "ftp://sources.redhat.com/pub/glibc/snapshots/${name}.tar.bz2";
    sha256 = "e317b854807f52cd539ed9b6bf8b1c2977e650e27e90baa787444bd3b74f5e72";
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
  ];

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";
}
