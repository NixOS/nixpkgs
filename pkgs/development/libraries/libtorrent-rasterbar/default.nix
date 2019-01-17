{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, automake, autoconf
, zlib, boost, openssl, libtool, python, libiconv, geoip, ncurses
}:

let
  version = "1.2.0";
  formattedVersion = lib.replaceChars ["."] ["_"] version;

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  name = "libtorrent-rasterbar-${version}";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "libtorrent_${formattedVersion}";
    sha256 = "08jb96063q0mdwphnfy6l80i0pfdqax6ydxvc3q663xr18aka8k5";
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
