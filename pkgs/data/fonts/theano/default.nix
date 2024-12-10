{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "theano";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/akryukov/theano/releases/download/v${version}/theano-${version}.otf.zip";
    stripRoot = false;
    hash = "sha256-9wnwHcRHB+AToOvGwZSXvHkQ8hqMd7Sdl26Ty/IwbPw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${pname}-${version}
    cp *.otf $out/share/fonts/opentype
    cp *.txt $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/akryukov/theano";
    description = "An old-style font designed from historic samples";
    maintainers = with maintainers; [
      raskin
      rycee
    ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
