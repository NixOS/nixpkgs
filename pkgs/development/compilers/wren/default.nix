{ lib
, stdenv
, fetchFromGitHub
, python3
, callPackage
}:
let
  cli =
    callPackage ./cli.nix { };
in
stdenv.mkDerivation rec {
  pname = "wren";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "wren-lang";
    repo = pname;
    rev = version;
    sha256 = "0w8n5lyn3wa1nmdyci0zi249w1qbq725cr1d9xsg067irq17v8k5";
  };

  buildPhase = ''
    make --directory projects/make
  '';

  doCheck = true;
  checkPhase = ''
    echo "======== Testing Wren ========"
    python3 util/test.py
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -r lib $out

    mkdir -p $out/bin
    cp ${cli}/bin/wren $out/bin/wren
  '';

  buildInputs = [ python3 ];

  meta = with lib; {
    description = "A small, fast, class-based concurrent scripting language";
    homepage = "https://wren.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
