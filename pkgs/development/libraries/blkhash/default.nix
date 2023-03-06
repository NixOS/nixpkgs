{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, asciidoc
, enableLibnbd ? stdenv.isLinux, libnbd
, makeWrapper
, meson
, ninja
, openssl
, pkg-config
, python3Packages
, qemu-utils
}:
let
  unity = fetchFromGitHub {
    owner = "ThrowTheSwitch";
    repo = "Unity";
    rev = "f9879bf7d82108c3eefd5fc378983317898616f3";
    sha256 = "sha256-AtW15e2ZBgOoqrA/5fM6GIjlIVLHVqwpBPCXo4UUZxc=";
  };
in
stdenv.mkDerivation rec {
  version = "0.7.1";
  pname = "blkhash";

  src = fetchFromGitLab {
    owner = "nirs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U43X/kYAVRxlzFS4PSIvmZoAJEgkcmqq/nTTqavCYpI=";
  };

  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${unity} unity
  )'';

  buildInputs = [ ] ++ lib.optional (enableLibnbd) libnbd;

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    ninja
    openssl
    pkg-config
  ];

  # don't enforce libnbd
  mesonAutoFeatures = "auto";

  postInstall = ''
    wrapProgram $out/bin/blksum --set PATH ${lib.makeBinPath [ qemu-utils ]}
  '';

  meta = with lib; {
    description = "Block based hash optimized for disk images";
    homepage = "https://gitlab.com/nirs/blkhash";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ noisersup ];
    platforms = platforms.unix;
  };
}
