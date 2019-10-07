{ stdenv, coreutils, fetchFromGitHub, cmake, meson, ninja, pkg-config, python3, git }:

stdenv.mkDerivation rec {
  pname = "boxfort-unstable";
  version = "2019-09-19";

  src = fetchFromGitHub
    { owner = "Snaipe";
      repo  = "BoxFort";
      rev   = "38fe63046fbabcae34ebc2ee9867d990ac28c4c5";
      sha256 = "03zy982d1frpk9fr4hbp1ql1ah06s0v6dy7a56d1zl3jjjljhrhn";
    };

  buildInputs =
    [ coreutils
      python3
    ];

  nativeBuildInputs =
    [ meson
      ninja
      cmake
      pkg-config
      git
    ];

  prePatch = ''
    patchShebangs ci/isdir.py
  '';

  meta = with stdenv.lib;
    { description = "Convenient & cross-platform sandboxing C library";
      homepage    = "https://github.com/Snaipe/BoxFort";
      license     = licenses.mit;
      platforms   = platforms.all;
      maintainers = with maintainers; [ thesola10 ];
    };
}
