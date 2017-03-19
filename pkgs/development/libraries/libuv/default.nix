{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
, ApplicationServices, CoreServices }:

stdenv.mkDerivation rec {
  version = "1.11.0";
  name = "libuv-${version}";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    sha256 = "02sm7f3l0shpfz25b77q2jjvlypc1mmz4zpzfgfmiplhgxxaa6la";
  };

  postPatch = let
    toDisable = [
      "getnameinfo_basic" # probably network-dependent
      "spawn_setuid_fails" "spawn_setgid_fails" "fs_chown" # user namespaces
      "getaddrinfo_fail" "getaddrinfo_fail_sync"
    ]
      # sometimes: timeout (no output), failed uv_listen
      ++ stdenv.lib.optionals stdenv.isDarwin [ "process_title" "emfile" ];
    tdRegexp = lib.concatStringsSep "\\|" toDisable;
    in lib.optionalString doCheck ''
      sed '/${tdRegexp}/d' -i test/test-list.h
    '';

  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  enableParallelBuilding = true;

  # These should be turned back on, but see https://github.com/NixOS/nixpkgs/issues/23651
  # For now the tests are just breaking large swaths of the nixpkgs binary cache for Darwin,
  # and I'd rather have everything else work at all than have stronger assurance here.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/libuv/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

}
