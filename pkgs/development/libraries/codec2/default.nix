{ lib
, stdenv
, fetchFromGitHub
, cmake
, freedvSupport ? false
, lpcnetfreedv
, codec2
}:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    hash = "sha256-p1WMp17PCnr50bXDSd6A4Je7AfKVHuLmyEue9221zPs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals freedvSupport [
    lpcnetfreedv
  ];

  # Install a binary that is used by openwebrx
  postInstall = ''
    install -Dm0755 src/freedv_rx -t $out/bin/
  '';

  # Swap keyword order to satisfy SWIG parser
  postFixup = ''
    sed -r -i 's/(\<_Complex)(\s+)(float|double)/\3\2\1/' $out/include/$pname/freedv_api.h
  '';

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/freedv_rx contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals freedvSupport [
    "-DLPCNET=ON"
  ];

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "https://www.rowetel.com/codec2.html";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
