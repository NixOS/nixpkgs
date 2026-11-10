{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uthash";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "troydhanson";
    repo = "uthash";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pEuBQVQSszuL7dIPZYSAyrr3tf6BTc/NWMBoFESCYkw=";
  };

  doCheck = true;
  nativeCheckInputs = [ perl ];
  checkTarget = "all";
  preCheck = "cd tests";

  installPhase = ''
    install -Dm644 $src/include/*.h -t $out/include
  '';

  meta = {
    description = "Hash table for C structures";
    homepage = "http://troydhanson.github.io/uthash";
    license = lib.licenses.bsd2; # it's one-clause, actually, as it's source-only
    platforms = lib.platforms.all;
  };
})
