{ stdenv, fetchFromGitHub, cmake, pkg-config, boxfort, libcsptr, dyncall, nanomsg }:

stdenv.mkDerivation rec {
  pname = "criterion";
  version = "2.3.3";

  src = fetchFromGitHub
    { owner = "Snaipe";
      repo = "Criterion";
      rev = "v${version}";
      fetchSubmodules = true;
      sha256 = "0y1ay8is54k3y82vagdy0jsa3nfkczpvnqfcjm5n9iarayaxaq8p";
    };

  buildInputs =
    [ boxfort
      libcsptr
      dyncall
      nanomsg
    ];

  nativeBuildInputs =
    [ cmake
      pkg-config
    ];

  # CMake needs a little help to find BoxFort and pkg-config
  preConfigure = ''
    mkdir -p .third-party
    ln -s ${boxfort} .third-party/boxfort
    ln -s ${pkg-config} .third-party/pkg-config
  '';

  meta = with stdenv.lib;
    { description = "A cross-platform C and C++ unit testing framework for the 21st century.";
      homepage    = "https://criterion.readthedocs.io";
      license     = licenses.mit;
      platforms   = platforms.all;
      maintainers = with maintainers; [ thesola10 ];
    };
  }
