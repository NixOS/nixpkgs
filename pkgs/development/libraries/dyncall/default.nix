{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "dyncall";
  version = "1.1";

  src = fetchurl {
    url = http://www.dyncall.org/r1.1/dyncall-1.1.tar.gz;
    # http://www.dyncall.org/r1.1/SHA256
    sha256 = "15c7x0k921lm5mml8gap2rkz3md7d56slp136kzk5f1d2hzzm5yg";
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
