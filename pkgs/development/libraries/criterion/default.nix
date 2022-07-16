{ stdenv
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
}
