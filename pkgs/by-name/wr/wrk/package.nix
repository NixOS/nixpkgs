{ lib, stdenv, fetchFromGitHub, luajit, openssl, perl }:

stdenv.mkDerivation rec {
  pname = "wrk";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "wg";
    repo = "wrk";
    rev = version;
    sha256 = "sha256-nCfA444p7krXOB3qRtDKWxWj9tsrDZsGf03ThtE1dXM=";
  };

  buildInputs = [ luajit openssl perl ];

  makeFlags = [ "WITH_LUAJIT=${luajit}" "WITH_OPENSSL=${openssl.dev}" "VER=${version}" ];

  preBuild = ''
    for f in src/*.h; do
      substituteInPlace $f \
        --replace "#include <luajit-2.0/" "#include <"
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  installPhase = ''
    mkdir -p $out/bin
    cp wrk $out/bin
  '';

  meta = with lib; {
    description = "HTTP benchmarking tool";
    homepage = "https://github.com/wg/wrk";
    longDescription = ''
      wrk is a modern HTTP benchmarking tool capable of generating
      significant load when run on a single multi-core CPU. It
      combines a multithreaded design with scalable event notification
      systems such as epoll and kqueue.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.unix;
    mainProgram = "wrk";
  };
}
