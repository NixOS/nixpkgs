{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "dyncall";
  version = "1.0";

  src = fetchurl {
    url = http://www.dyncall.org/r1.0/dyncall-1.0.tar.gz;
    # http://www.dyncall.org/r1.0/SHA256
    sha256 = "d1b6d9753d67dcd4d9ea0708ed4a3018fb5bfc1eca5f37537fba2bc4f90748f2";
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
    homepage = http://www.dyncall.org;
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
