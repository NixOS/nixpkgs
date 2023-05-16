{ lib, stdenv, fetchFromGitHub, copyPkgconfigItems, makePkgconfigItem }:

stdenv.mkDerivation rec {
  pname = "stb";
<<<<<<< HEAD
  version = "unstable-2023-01-29";
=======
  version = "unstable-2021-09-10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
<<<<<<< HEAD
    rev = "5736b15f7ea0ffb08dd38af21067c314d6a3aae9";
    hash = "sha256-s2ASdlT3bBNrqvwfhhN6skjbmyEnUgvNOrvhgUSRj98=";
=======
    rev = "af1a5bc352164740c1cc1354942b1c6b72eacb8a";
    sha256 = "0qq35cd747lll4s7bmnxb3pqvyp2hgcr9kyf758fax9lx76iwjhr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with maintainers; [ jfrankenau ];
  };
}
