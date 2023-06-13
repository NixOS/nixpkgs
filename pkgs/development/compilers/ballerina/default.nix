{ ballerina, lib, writeText, runCommand, makeWrapper, fetchzip, stdenv, openjdk }:
let
  version = "2201.6.0";
  codeName = "swan-lake";
in stdenv.mkDerivation {
  pname = "ballerina";
  inherit version;

  src = fetchzip {
    url = "https://dist.ballerina.io/downloads/${version}/ballerina-${version}-${codeName}.zip";
    sha256 = "sha256-yttRswqNq8Tam1OwnC9klwrryDDqdHMzzRs9T9pYlnU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    cp -rv distributions/ballerina-${version} $out
    runHook postInstall
  '';
  preFixup = ''
    wrapProgram $out/bin/bal --set JAVA_HOME ${openjdk}
  '';

  passthru.tests.smokeTest = let
    helloWorld = writeText "hello-world.bal" ''
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    '';
  in runCommand "ballerina-${version}-smoketest" { } ''
    ${ballerina}/bin/bal run ${helloWorld} >$out
    read result <$out
    [[ $result = "Hello, World!" ]]
  '';

  meta = with lib; {
    description = "An open-source programming language for the cloud";
    license = licenses.asl20;
    platforms = openjdk.meta.platforms;
    maintainers = with maintainers; [ eigengrau ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
