{ stdenv, lib, fetchFromGitHub, ant, jdk8 }:

stdenv.mkDerivation rec {
  pname = "jna";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "java-native-access";
    repo = pname;
    rev = version;
    hash = "sha256-FJXYej49soHPa+kAUeLZYzbw+NnFoag2LdKrTihPWvE=";
  };

  nativeBuildInputs = [ ant jdk8 ];

  buildPhase = ''
    runHook preBuild
    rm -r dist # remove prebuilt files
    ant dist
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/java dist/jna{,-platform}.jar
    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Java Native Access";
    license = with licenses; [ lgpl21 asl20 ];
    maintainers = with maintainers; [ nagy ];
    platforms = platforms.linux;
    changelog = "https://github.com/java-native-access/jna/blob/${version}/CHANGES.md";
  };
}
