{ alsa-lib
, autoPatchelfHook
, dists
, fetchzip
, lib
, setJavaClassPath
, stdenv
, stdenvNoCC
, xorg
, zlib
,
}:
let dist = dists.${stdenv.hostPlatform.system};
in stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zing";
  inherit (dist) version jdkVersion;

  src = fetchzip { inherit (dist) url hash; };

  buildInputs = [ alsa-lib stdenv.cc.cc.lib xorg.libXrender xorg.libXtst zlib ];
  nativeBuildInputs = [ autoPatchelfHook ];
  propagatedBuildInputs = [ setJavaClassPath ];

  installPhase = ''
    runHook preInstall

    cp -R ./ $out

    ln -s $out/include/linux/*_md.h $out/include

    mkdir -p $out/nix-support
    cat <<EOF > $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF

    runHook postInstall
  '';

  helloWorldJava = ''
    public class HelloWorld {
      public static void main(String[] args) {
        System.out.println("Hello World");
      }
    }
  '';
  passAsFile = [ "helloWorldJava" ];

  doInstallCheck = stdenvNoCC.buildPlatform.system
    == stdenvNoCC.hostPlatform.system;
  installCheckPhase = ''
    runHook preInstallCheck

    pushd "$(mktemp -d)"

    cp "$helloWorldJavaPath" HelloWorld.java
    $out/bin/javac HelloWorld.java
    $out/bin/java HelloWorld | grep "Hello World"

    popd

    runHook postInstallCheck
  '';

  strictDeps = true;

  meta = with lib; {
    homepage = "https://www.azul.com/products/prime";
    changelog = "https://docs.azul.com/prime/release-notes";
    downloadPage = "https://www.azul.com/downloads/#prime";
    description = "High performance JVM implementation with low GC pause time";
    sourceProvenance = with sourceTypes; [ binaryBytecode binaryNativeCode ];
    license = licenses.unfree;
    platforms = lib.attrNames dists;
    maintainers = with maintainers; [ terrorjack ];
    mainProgram = "java";
  };
})
