{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, automake, autoconf
, zlib, boost, openssl, libtool, python, libiconv, geoip, ncurses
}:

let
  version = "1.1.9";
  formattedVersion = lib.replaceChars ["."] ["_"] version;

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  name = "libtorrent-rasterbar-${version}";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "libtorrent-${formattedVersion}";
    sha256 = "04w3pjzd6q9wplj1dcphylxn1i2b2x0iw1l0ma58ymh14swdah7a";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];
  buildInputs = [ boostPython openssl zlib python libiconv geoip ncurses ];
  preConfigure = "./autotool.sh";

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

  configureFlags = [
    "--enable-python-binding"
    "--with-libgeoip=system"
    "--with-libiconv=yes"
    "--with-boost=${boostPython.dev}"
    "--with-boost-libdir=${boostPython.out}/lib"
    "--with-libiconv=yes"
  ];

  meta = with stdenv.lib; {
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
