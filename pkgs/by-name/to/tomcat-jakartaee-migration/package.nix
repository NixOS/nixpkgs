{
  lib,
  maven,
  fetchFromGitHub,
  jre_minimal,
  makeWrapper,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.instrument"
      "java.logging"
    ];
  };
in
maven.buildMavenPackage (finalAttrs: {
  pname = "tomcat-jakartaee-migration";
  version = "1.0.13";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tomcat-jakartaee-migration";
    tag = finalAttrs.version;
    hash = "sha256-0yqE88meMQL/VI7QuaOp6EdkNtMz7QPC3c4brH6KGmw=";
  };

  mvnHash = "sha256-xed73XcGCdob9RqH7Z8DfzZ3vu2+lQDimdqAlfIyLQk=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/jakartaee-migration-${finalAttrs.version}-shaded.jar $out/share/java/jakartaee-migration.jar
    makeWrapper ${lib.getExe jre} $out/bin/javax2jakarta \
      --add-flags "-jar $out/share/java/jakartaee-migration.jar"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    echo 'import javax.servlet.http.HttpServlet;' > A.java
    $out/bin/javax2jakarta A.java B.java
    grep -q 'import jakarta.servlet.http.HttpServlet;' B.java

    runHook postInstallCheck
  '';

  meta = {
    description = "Tool to migrate Java EE applications to Jakarta EE";
    homepage = "https://github.com/apache/tomcat-jakartaee-migration";
    changelog = "https://github.com/apache/tomcat-jakartaee-migration/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "javax2jakarta";
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
