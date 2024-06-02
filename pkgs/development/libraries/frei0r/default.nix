{ lib
, stdenv
, fetchFromGitHub
, cairo
, cmake
, opencv
, pcre
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "frei0r-plugins";
  version = "2.3.2";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "frei0r";
    rev = "v${version}";
    hash = "sha256-shPCCKcmacSB/mqwLU6BPR1p+/9Myg759MMehj9yijI=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    cairo
    (lib.getOutput "cxxdev" opencv)
    pcre
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/lib/frei0r-1/*.so* ; do
      ln -s $f "''${f%.*}.dylib"
    done
  '';

  meta = with lib; {
    homepage = "https://frei0r.dyne.org";
    description = "Minimalist, cross-platform, shared video plugins";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
