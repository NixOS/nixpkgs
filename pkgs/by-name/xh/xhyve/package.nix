{
  stdenv,
  lib,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "xhyve";
  version = "20210203";

  src = fetchFromGitHub {
    owner = "machyve";
    repo = "xhyve";
    rev = "83516a009c692ea5d2993d1071e68d05d359b11e";
    sha256 = "1pjdg4ppy6qh3vr1ls5zyw3jzcvwny9wydnmfpadwij1hvns7lj3";
  };

  buildInputs = [
    zlib
  ];

  # Don't use git to determine version
  prePatch = ''
    substituteInPlace Makefile \
      --replace 'shell git describe --abbrev=6 --dirty --always --tags' "$version"
  '';

  makeFlags = [
    "CFLAGS+=-Wno-shift-sign-overflow"
    ''CFLAGS+=-DVERSION=\"${version}\"''
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/xhyve $out/bin
  '';

  meta = with lib; {
    description = "Lightweight Virtualization on macOS Based on bhyve";
    homepage = "https://github.com/mist64/xhyve";
    maintainers = [ maintainers.lnl7 ];
    license = licenses.bsd2;
    platforms = platforms.darwin;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
