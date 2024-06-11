{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, libffi
, pkg-config
, texinfo
, stripJavaArchivesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jffi";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "jnr";
    repo = "jffi";
    rev = "jffi-${finalAttrs.version}";
    hash = "sha256-aBQkkZyXZkaJc4sr/jHnIRaJYP116u4Jqsr9XXzfOBA=";
  };

  nativeBuildInputs = [
    ant
    jdk
    pkg-config
    texinfo
    stripJavaArchivesHook
  ];

  buildInputs = [ libffi ];

  # The pkg-config script in the build.xml doesn't work propery
  # set the lib path manually to work around this.
  env.LIBFFI_LIBS = "${libffi}/lib/libffi${stdenv.hostPlatform.extensions.sharedLibrary}";
  env.ANT_ARGS = "-Duse.system.libffi=1";

  buildPhase = ''
    runHook preBuild
    ant jar
    ant archive-platform-jar
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ant test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 dist/*.jar -t $out/share/java
    runHook postInstall
  '';

  # nix can't detect libffi as a dependency inside the jar file, so we create
  # a dummy file with the path to libffi, to make sure that nix knows about it
  postFixup = ''
    mkdir -p $out/nix-support
    echo ${libffi} > $out/nix-support/depends
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Java Foreign Function Interface ";
    homepage = "https://github.com/jnr/jffi";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
})
