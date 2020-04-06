{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "dyncall";
  version = "1.1";

  src = fetchurl {
    url = https://www.dyncall.org/r1.1/dyncall-1.1.tar.gz;
    # https://www.dyncall.org/r1.1/SHA256
    sha256 = "cf97fa3f142db832ff34235caa4d69a7d5f16716573d446b2d95069126e88795";
  };

  # XXX: broken tests, failures masked, lets avoid crashing a bunch for now :)
  doCheck = false;

  # install bits not automatically installed
  postInstall = ''
    # install cmake modules to make using dyncall easier
    # This is essentially what -DINSTALL_CMAKE_MODULES=ON if using cmake build
    # We don't use the cmake-based build since it installs different set of headers
    # (mostly fewer headers, but installs dyncall_alloc_wx.h "instead" dyncall_alloc.h)
    # and we'd have to patch the cmake module installation to not use CMAKE_ROOT anyway :).
    install -D -t $out/lib/cmake ./buildsys/cmake/Modules/Find*.cmake

    # manpages are nice, install them
    # doing this is in the project's "ToDo", so check this when updating!
    install -D -t $out/share/man/man3 ./*/*.3
  '';

  meta = with stdenv.lib; {
    description = "Highly dynamic multi-platform foreign function call interface library";
    homepage = https://www.dyncall.org;
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
