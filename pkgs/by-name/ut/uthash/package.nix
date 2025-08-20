{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "uthash";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "troydhanson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F0M5ENT3bMn3dD16Oaq9mBFYOWzVliVWupAIrLc2nkQ=";
  };

  doCheck = true;
  nativeCheckInputs = [ perl ];
  checkTarget = "all";
  preCheck = "cd tests";

  installPhase = ''
    install -Dm644 $src/include/*.h -t $out/include
  '';

  meta = with lib; {
    description = "Hash table for C structures";
    homepage = "http://troydhanson.github.io/uthash";
    license = licenses.bsd2; # it's one-clause, actually, as it's source-only
    platforms = platforms.all;
  };
}
