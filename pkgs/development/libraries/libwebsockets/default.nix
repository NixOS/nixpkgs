{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, zlib
, libuv
, fetchpatch
# External poll is required for e.g. mosquitto, but discouraged by the maintainer.
, withExternalPoll ? false
}:

let
  generic = { version, sha256, patches ? [] }: stdenv.mkDerivation rec {
    pname = "libwebsockets";
    inherit version;

    src = fetchFromGitHub {
      owner = "warmcat";
      repo = "libwebsockets";
      rev = "v${version}";
      inherit sha256;
    };

    inherit patches;

    buildInputs = [ openssl zlib libuv ];

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DLWS_WITH_PLUGINS=ON"
      "-DLWS_WITH_IPV6=ON"
      "-DLWS_WITH_SOCKS5=ON"
      # Required since v4.2.0
      "-DLWS_BUILD_HASH=no_hash"
    ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-DLWS_WITHOUT_TESTAPPS=ON"
      ++ lib.optional withExternalPoll "-DLWS_WITH_EXTERNAL_POLL=ON";

    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=unused-but-set-variable";

    postInstall = ''
      rm -r ${placeholder "out"}/share/libwebsockets-test-server
    '';

    # $out/share/libwebsockets-test-server/plugins/libprotocol_*.so refers to crtbeginS.o
    disallowedReferences = [ stdenv.cc.cc ];

    meta = with lib; {
      description = "Light, portable C library for websockets";
      longDescription = ''
        Libwebsockets is a lightweight pure C library built to
        use minimal CPU and memory resources, and provide fast
        throughput in both directions.
      '';
      homepage = "https://libwebsockets.org/";
      # Relicensed from LGPLv2.1+ to MIT with 4.0. Licensing situation
      # is tricky, see https://github.com/warmcat/libwebsockets/blob/main/LICENSE
      license = with licenses; [ mit publicDomain bsd3 asl20 ];
      maintainers = with maintainers; [ mindavi ];
      platforms = platforms.all;
    };
  };

in {
  libwebsockets_3_1 = generic {
    sha256 = "1w1wz6snf3cmcpa3f4dci2nz9za2f5rrylxl109id7bcb36xhbdl";
    version = "3.1.0";
  };

  libwebsockets_3_2 = generic {
    version = "3.2.2";
    sha256 = "0m1kn4p167jv63zvwhsvmdn8azx3q7fkk8qc0fclwyps2scz6dna";
  };

  libwebsockets_4_2 = generic {
    version = "4.2.1";
    sha256 = "sha256-C+WGfNF4tAgbp/7aRraBgjNOe4I5ihm+8CGelXzfxbU=";
  };

  libwebsockets_4_3 = generic {
    version = "4.3.1";
    sha256 = "sha256-lB3JHh058cQc5rycLnHk3JAOgtku0nRCixN5U6lPKq8=";
    patches = [
      # fixes the propagated cmake files, fixing the build of ttyd
      # see also https://github.com/tsl0922/ttyd/issues/918
      (fetchpatch {
        url = "https://github.com/warmcat/libwebsockets/commit/99a8b9c4422bed45c8b7412a1e121056f2a6132a.patch";
        hash = "sha256-zHBo2ZEayvibM+jzeVaZqySxghaOLUglpSFwuGhl6HM=";
      })
    ];
  };
}
