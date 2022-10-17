{ lib, stdenv, fetchFromGitHub, copyPkgconfigItems, makePkgconfigItem }:

stdenv.mkDerivation rec {
  pname = "stb";
  version = "unstable-2021-09-10";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "af1a5bc352164740c1cc1354942b1c6b72eacb8a";
    sha256 = "0qq35cd747lll4s7bmnxb3pqvyp2hgcr9kyf758fax9lx76iwjhr";
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
