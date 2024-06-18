{ lib, stdenv, fetchFromGitHub, pkg-config, automake, autoconf
, zlib, boost, openssl, libtool, python, libiconv, ncurses, SystemConfiguration
}:

let
  version = "1.2.11";

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "05qm8mcyxsnb6zb8nckln1gkk8ncwzfhsz7d7p3fhx6gdsc8j71b";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ automake autoconf libtool pkg-config ];

  buildInputs = [ boostPython openssl zlib python libiconv ncurses ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

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
    homepage = "https://libtorrent.org/";
    description = "C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
