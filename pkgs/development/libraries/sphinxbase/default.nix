{ lib, stdenv
, autoreconfHook
, fetchFromGitHub
, bison
, pkg-config
, python3
, swig2 # 2.0
, multipleOutputs ? false #Uses incomplete features of nix!
}:

stdenv.mkDerivation {
  pname = "sphinxbase";
  version = "unstable-2022-02-21";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "sphinxbase";
    rev = "3612ab4e8de9172e2b7e2401f4ca1ad122c29fde";
    hash = "sha256-O/Olx7S+g4DftN/ahVXr2dQUtoQe4hxQUsz8Z7We0RI=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ swig2 python3 bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = "https://cmusphinx.github.io";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };

} // (lib.optionalAttrs multipleOutputs {
  outputs = [ "out" "lib" "headers" ];

  postInstall = ''
    mkdir -p $lib
    cp -av $out/lib* $lib

    mkdir -p $headers
    cp -av $out/include $headers
  '';
})
