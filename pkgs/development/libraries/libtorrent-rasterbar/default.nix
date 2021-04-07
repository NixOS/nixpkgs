{ lib, stdenv, fetchFromGitHub, cmake
, zlib, boost, openssl, python, ncurses, SystemConfiguration
}:

let
  version = "2.0.3";

  # Make sure we override python, so the correct version is chosen
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "0c5g2chylhkwwssfab9gw0b7bm3raj08yzgia7j4d044lp8gflnd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boostPython openssl zlib python ncurses ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

  cmakeFlags = [
    "-Dpython-bindings=on"
  ];

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ maintainers.phreedom ];
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
