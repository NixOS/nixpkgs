{ lib, stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, msgpack
, libvpx, check, libconfig, pkg-config }:

let
  generic = { version, sha256 }:
  stdenv.mkDerivation {
    pname = "libtoxcore";
    inherit version;

    src = fetchFromGitHub {
      owner  = "TokTok";
      repo   = "c-toxcore";
      rev    = "v${version}";
      inherit sha256;
    };

    cmakeFlags = [
      "-DBUILD_NTOX=ON"
      "-DDHT_BOOTSTRAP=ON"
      "-DBOOTSTRAP_DAEMON=ON"
    ];

    buildInputs = [
      libsodium msgpack ncurses libconfig
    ] ++ lib.optionals (!stdenv.isAarch32) [
      libopus libvpx
    ];

    nativeBuildInputs = [ cmake pkg-config ];

    doCheck = false; # hangs, tries to access the net?
    checkInputs = [ check ];

    postFixup =''
      sed -i $out/lib/pkgconfig/*.pc \
        -e "s|^libdir=.*|libdir=$out/lib|" \
        -e "s|^includedir=.*|includedir=$out/include|"
    '';

    meta = with lib; {
      broken = stdenv.isDarwin;
      description = "P2P FOSS instant messaging application aimed to replace Skype";
      homepage = "https://tox.chat";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ peterhoeg ];
      platforms = platforms.all;
    };
  };

in {
  libtoxcore_0_1 = generic {
    version = "0.1.11";
    sha256 = "1fya5gfiwlpk6fxhalv95n945ymvp2iidiyksrjw1xw95fzsp1ij";
  };

  libtoxcore_0_2 = generic {
    version = "0.2.17";
    sha256 = "sha256-SOI6QKOSt/EK9JDrSaV6CrD5sx8aYb5ZL3StYq8u/Dg=";
  };
}
