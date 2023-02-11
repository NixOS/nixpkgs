{ lib, stdenv, fetchurl, cmake, libsodium, ncurses, libopus, msgpack
, libvpx, check, libconfig, pkg-config }:

let buildToxAV = !stdenv.isAarch32;
in stdenv.mkDerivation rec {
  pname = "libtoxcore";
  version = "0.2.18";

  src =
    # We need the prepared sources tarball.
    fetchurl {
      url =
        "https://github.com/TokTok/c-toxcore/releases/download/v${version}/c-toxcore-${version}.tar.gz";
      sha256 = "sha256-8pQFN5mIY1k+KLxqa19W8JZ19s2KKDJre8MbSDbAiUI=";
    };

  cmakeFlags =
    [ "-DBUILD_NTOX=ON" "-DDHT_BOOTSTRAP=ON" "-DBOOTSTRAP_DAEMON=ON" ]
    ++ lib.optional buildToxAV "-DMUST_BUILD_TOXAV=ON";

  buildInputs = [
    libsodium msgpack ncurses libconfig
  ] ++ lib.optionals buildToxAV [
    libopus libvpx
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  doCheck = true;
  nativeCheckInputs = [ check ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/toxcore.pc \
      --replace '=''${prefix}/' '=' \

  '';
  # We might be getting the wrong pkg-config file anyway:
  # https://github.com/TokTok/c-toxcore/issues/2334

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = "https://tox.chat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg ehmry ];
    platforms = platforms.all;
  };
}
