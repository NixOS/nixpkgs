{ stdenv, fetchFromGitHub, autoreconfHook, libibverbs, librdmacm, libevent

# Linux only deps
, numactl, kernel ? null
}:

stdenv.mkDerivation rec {
  name = "accelio-${version}${stdenv.lib.optionalString (kernel != null) "-kernel"}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "accelio";
    repo = "accelio";
    rev = "v${version}";
    sha256 = "0cxiwn63481m88zisd0pqs6g0h5k1amz2kidwyxkdbl6xgf70cwd";
  };

  postPatch = ''
    # Don't build broken examples
    sed -i '/AC_CONFIG_SUBDIRS(\[\(examples\|tests\)\/kernel/d' configure.ac

    # Allow the installation of xio kernel headers
    sed -i 's,/opt/xio,''${out},g' src/kernel/xio/Makefile.in

    # Don't install ldconfig entries
    sed -i '\,/etc/ld.so.conf.d/libxio.conf,d' src/usr/Makefile.am
    sed -i '\,/sbin/ldconfig,d' src/usr/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libevent ];
  propagatedBuildInputs = [ libibverbs librdmacm ]
    ++ stdenv.lib.optional stdenv.isLinux numactl;

  configureFlags = [
    "--enable-rdma"
    "--disable-raio-build"
  ] ++ stdenv.lib.optionals (kernel != null) [
    "--enable-kernel-module"
    "--with-kernel=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "--with-kernel-build=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  INSTALL_MOD_PATH = "\${out}";

  meta = with stdenv.lib; {
    homepage = http://www.accelio.org/;
    description = "a high-performance asynchronous reliable messaging and RPC library optimized for hardware acceleration";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ freebsd;
    maintainers = with maintainers; [ wkennington ];
  };
}
