{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.57.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_57_0.tar.bz2";
    sha256 = "0rs94vdmg34bwwj23fllva6mhrml2i7mvmlb11zyrk1k5818q34i";
  };

  patches = if stdenv.isCygwin then [
      ./cygwin-fedora-boost-1.50.0-fix-non-utf8-files.patch
      ./cygwin-fedora-boost-1.50.0-pool.patch
      ./cygwin-fedora-boost-1.57.0-mpl-print.patch
      ./cygwin-fedora-boost-1.57.0-spirit-unused_typedef.patch
      ./cygwin-fedora-boost-1.54.0-locale-unused_typedef.patch
      ./cygwin-fedora-boost-1.54.0-python-unused_typedef.patch
      ./cygwin-fedora-boost-1.57.0-pool-test_linking.patch
      ./cygwin-fedora-boost-1.54.0-pool-max_chunks_shadow.patch
      ./cygwin-fedora-boost-1.57.0-signals2-weak_ptr.patch
      ./cygwin-fedora-boost-1.57.0-uuid-comparison.patch
      ./cygwin-fedora-boost-1.57.0-move-is_class.patch
      ./cygwin-1.40.0-cstdint-cygwin.patch
      ./cygwin-1.57.0-asio-cygwin.patch
      ./cygwin-1.55.0-asio-MSG_EOR.patch
      ./cygwin-1.57.0-config-cygwin.patch
      ./cygwin-1.57.0-context-cygwin.patch
      ./cygwin-1.57.0-filesystem-cygwin.patch
      ./cygwin-1.55.0-interlocked-cygwin.patch
      ./cygwin-1.40.0-iostreams-cygwin.patch
      ./cygwin-1.57.0-locale-cygwin.patch
      ./cygwin-1.57.0-log-cygwin.patch
      ./cygwin-1.40.0-python-cygwin.patch
      ./cygwin-1.40.0-regex-cygwin.patch
      ./cygwin-1.57.0-smart_ptr-cygwin.patch
      ./cygwin-1.57.0-system-cygwin.patch
      ./cygwin-1.45.0-jam-cygwin.patch
      ./cygwin-1.50.0-jam-pep3149.patch
    ] else null;
})
