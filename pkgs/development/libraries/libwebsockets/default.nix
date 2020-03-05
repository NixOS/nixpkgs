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
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";

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
    version = "3.2.2";
    sha256 = "0m1kn4p167jv63zvwhsvmdn8azx3q7fkk8qc0fclwyps2scz6dna";
  };

  libwebsockets_4_0 = generic {
    version = "4.0.0";
    sha256 = "1kba64whi5lrl2y83mnqp2cqry5j28fkzlqy9x2ki6zmryh2574j";
  };
}
