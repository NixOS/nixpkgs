{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {

  version = "2.4.1";
  pname = "criterion";

  src = fetchurl {
    url = "https://github.com/Snaipe/Criterion/releases/download/v${version}/criterion-${version}-linux-x86_64.tar.xz";
    sha256 = "0907r10bk8wp1pmb0ndsndn5qxaj5nyk8zb6jnwi0vqg0g46p5id";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir $out
    cp -r criterion-${version}/* $out/
  '';
  meta = with lib; {
    description = "A cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    license = licenses.mit;
    maintainers = with maintainers; [
      thesola10
      Yumasi
    ];
    platforms = platforms.unix;
  };
}
