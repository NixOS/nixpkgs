{
  lib,
  stdenv,
  fetchurl,
  jdk11_headless,
  makeWrapper,
  nixosTests,
  bash,
  coreutils,
}:
let
  # Latest supported LTS JDK for Zookeeper 3.9:
  # https://zookeeper.apache.org/doc/r3.9.5/zookeeperAdmin.html#sc_requiredSoftware
  jre = jdk11_headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zookeeper";
  version = "3.9.5"; # Don't forget to update zookeeper_mt's hash!

  src = fetchurl {
    url = "mirror://apache/zookeeper/zookeeper-${finalAttrs.version}/apache-zookeeper-${finalAttrs.version}-bin.tar.gz";
    hash = "sha512-uqHCHdpNVyOPynUeT6K78dr/mihhKxJeSX3M1cGI7mRJ4veZR+R0wt1NGZknidTTayexui/rgMKwxF598OIqqA==";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R conf docs lib $out
    mkdir -p $out/bin
    cp -R bin/{zkCli,zkCleanup,zkEnv,zkServer,zkSnapShotToolkit,zkTxnLogToolkit}.sh $out/bin
    patchShebangs $out/bin
    substituteInPlace $out/bin/zkServer.sh \
        --replace-fail /bin/echo ${coreutils}/bin/echo
    for i in $out/bin/{zkCli,zkCleanup,zkServer,zkSnapShotToolkit,zkTxnLogToolkit}.sh; do
      wrapProgram $i \
        --set JAVA_HOME "${jre}" \
        --prefix PATH : "${bash}/bin"
    done
    chmod -x $out/bin/zkEnv.sh
    runHook postInstall
  '';

  passthru = {
    tests = {
      nixos = nixosTests.zookeeper;
    };
    inherit jre;
  };

  meta = {
    homepage = "https://zookeeper.apache.org";
    description = "Apache Zookeeper";
    changelog = "https://zookeeper.apache.org/doc/r${finalAttrs.version}/releasenotes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nathan-gs
      ztzg
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
