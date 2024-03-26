{ lib, stdenv, fetchFromGitHub, copyPkgconfigItems, makePkgconfigItem }:

stdenv.mkDerivation rec {
  pname = "stb";
  version = "unstable-2023-01-29";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "5736b15f7ea0ffb08dd38af21067c314d6a3aae9";
    hash = "sha256-s2ASdlT3bBNrqvwfhhN6skjbmyEnUgvNOrvhgUSRj98=";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "stb";
      version = "1";
      cflags = [ "-I${variables.includedir}/stb" ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
      };
      inherit (meta) description;
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/stb
    cp *.h $out/include/stb/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Single-file public domain libraries for C/C++";
    homepage = "https://github.com/nothings/stb";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
