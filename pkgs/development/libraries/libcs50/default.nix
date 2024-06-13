{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcs50";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "libcs50";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A4CEU5wfwykVTDIsKZnQ8co+6RwBGYGZEZxRFzQTKBI=";
  };

  patchPhase = ''
    sed -i -e /ldconfig/d Makefile
  '';

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out"
  '' + lib.optionalString stdenv.isLinux ''
    ln -sf $out/lib/libcs50.so.11.0.2 $out/lib/libcs50.so.11
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cs50/libcs50";
    description = "CS50 Library for C";
    license = licenses.gpl3Only;
    # At least tested on these but maybe this works on more?
    platforms = lib.platforms.unix;
  };
})
