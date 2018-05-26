{ stdenv, fetchFromGitHub, cmake, libsodium, ncurses, libopus, libmsgpack
, libvpx, check, libconfig, pkgconfig }:

let
  generic = { version, sha256 }:
  stdenv.mkDerivation rec {
    name = "libtoxcore-${version}";

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
      libsodium libmsgpack ncurses libconfig
    ] ++ stdenv.lib.optionals (!stdenv.isAarch32) [
      libopus libvpx
    ];

    nativeBuildInputs = [ cmake pkgconfig ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "P2P FOSS instant messaging application aimed to replace Skype";
      homepage = https://tox.chat;
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ peterhoeg ];
      platforms = platforms.all;
    };
  };

in rec {
  libtoxcore_0_1 = generic {
    version = "0.1.11";
    sha256 = "1fya5gfiwlpk6fxhalv95n945ymvp2iidiyksrjw1xw95fzsp1ij";
  };

  libtoxcore_0_2 = generic {
    version = "0.2.2";
    sha256 = "1463grbbv009pj2g6dbnyk4lr871vw41962m63v21mmp6dkrr7r5";
  };
}
