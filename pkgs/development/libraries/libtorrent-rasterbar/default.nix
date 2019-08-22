{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, zlib, boost, openssl, python, libiconv, geoip, ncurses
}:

let
  version = "1.2.1";
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
    sha256 = "0sl7gq6a98w4ksq92w3ywkqachrpbwlbmhazgvlcncik7bq1gkjj";
  };

  preAutoreconf = ''
    install -Dm444 m4/config.rpath -t build-aux
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ boostPython openssl zlib python libiconv geoip ncurses ];

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
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    homepage = "https://libtorrent.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
