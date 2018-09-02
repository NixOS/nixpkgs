{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.59.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_59_0.tar.bz2";
    sha256 = "1jj1aai5rdmd72g90a3pd8sw9vi32zad46xv5av8fhnr48ir6ykj";
  };

  patches = stdenv.lib.optionals stdenv.isCygwin [
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
  ];

  meta = {
    homepage = http://boost.org/;
    description = "Collection of C++ libraries";
    license = stdenv.lib.licenses.boost;

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ peti wkennington ];
  };
})
