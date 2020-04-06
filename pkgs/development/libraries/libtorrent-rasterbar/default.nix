{ stdenv, lib, fetchFromGitHub, pkgconfig, automake, autoconf
, zlib, boost, openssl, libtool, python, libiconv, geoip, ncurses
}:

let
  version = "1.2.5";
  formattedVersion = lib.replaceChars ["."] ["_"] version;

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "libtorrent-${formattedVersion}";
    sha256 = "0nwdsv6d2gkdsh7l5a46g6cqx27xwh3msify5paf02l1qzjy4s5l";
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
