{ stdenv, lib, fetchFromGitHub, pkg-config, automake, autoconf
, zlib, boost, openssl, libtool, python, libiconv, ncurses
}:

let
  version = "1.1.11";
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
    rev = "libtorrent_${formattedVersion}";
    sha256 = "0nwdsv6d2gkdsh7l5a46g6cqx27xwh3msify5paf02l1qzjy4s5l";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ automake autoconf libtool pkg-config ];
  buildInputs = [ boostPython openssl zlib python libiconv ncurses ];
  preConfigure = "./autotool.sh";

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

  configureFlags = [
    "--enable-python-binding"
    "--with-libiconv=yes"
    "--with-boost=${boostPython.dev}"
    "--with-boost-libdir=${boostPython.out}/lib"
  ];

  meta = with lib; {
    # darwin: never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/libtorrent-rasterbar-1_1_x.x86_64-darwin
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
