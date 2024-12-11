{ lib, buildPythonPackage, unbound, openssl, expat, libevent, swig, python, stdenv }:

buildPythonPackage rec {
  pname = "pyunbound";
  inherit (unbound) version src;
  pyproject = false; # Built with configure script

  patches = unbound.patches or null;

  nativeBuildInputs = [ swig ];

  buildInputs = [ openssl expat libevent python ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace "\$(DESTDIR)\$(PYTHON_SITE_PKG)" "$out/${python.sitePackages}" \
      --replace "\$(LIBTOOL) --mode=install cp _unbound.la" "cp _unbound.la"
  '';

  preConfigure = "export PYTHON_VERSION=${python.pythonVersion}";

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat.dev}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=\${out}/bin"
    "--enable-pie"
    "--enable-relro-now"
    "--with-pyunbound"
    "DESTDIR=$out"
    "PREFIX="
  ];

  preInstall = ''
    mkdir -p $out/${python.sitePackages} $out/etc/${pname}
    cp .libs/_unbound.so .libs/libunbound.so* $out/${python.sitePackages}
    substituteInPlace _unbound.la \
      --replace "-L.libs $PWD/libunbound.la" "-L$out/${python.sitePackages}"
  '';

  installFlags = [
    "configfile=\${out}/etc/unbound/unbound.conf"
    "pyunbound-install"
    "lib"
  ];

  # All we want is the Unbound Python module
  postInstall = ''
    # Generate the built in root anchor and root key and store these in a logical place
    # to be used by tools depending only on the Python module
    $out/bin/unbound-anchor -l | head -1 > $out/etc/${pname}/root.anchor
    $out/bin/unbound-anchor -l | tail --lines=+2 - > $out/etc/${pname}/root.key
    # We don't need anything else
    rm -r $out/bin $out/share $out/include $out/etc/unbound
  ''
  # patchelf is only available on Linux and no patching is needed on darwin
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --replace-needed libunbound.so.8 $out/${python.sitePackages}/libunbound.so.8 $out/${python.sitePackages}/_unbound.so
  '';

  meta = with lib; {
    description = "Python library for Unbound, the validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = "https://www.unbound.net";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.unix;
  };
}
