{ fetchFromGitHub, stdenv, cmake, openssl, zlib, libuv }:

let
  generic = { version, sha256 }: stdenv.mkDerivation rec {
    pname = "libwebsockets";
    inherit version;

    src = fetchFromGitHub {
      owner = "warmcat";
      repo = "libwebsockets";
      rev = "v${version}";
      inherit sha256;
    };

    buildInputs = [ openssl zlib libuv ];

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [ "-DLWS_WITH_PLUGINS=ON" ];

    meta = with stdenv.lib; {
      description = "Light, portable C library for websockets";
      longDescription = ''
        Libwebsockets is a lightweight pure C library built to
        use minimal CPU and memory resources, and provide fast
        throughput in both directions.
      '';
      homepage = "https://libwebsockets.org/";
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

in
rec {
  libwebsockets_3_1 = generic {
    sha256 = "1w1wz6snf3cmcpa3f4dci2nz9za2f5rrylxl109id7bcb36xhbdl";
    version = "3.1.0";
  };

  libwebsockets_3_2 = generic {
    version = "3.2.0";
    sha256 = "0ac5755h3w1pl6cznqbvg63dwkqy544fqlhvqyp7s11hgs7jx6l8";
  };

  libwebsockets = libwebsockets_3_2;
}
