{ stdenv, fetchurl, graalvm8, glibcLocales }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "babashka";
  version = "0.0.97";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-reflection.json";
    sha256 = "1gd9ih9l02n1j9qkbxb36d3cb5sddwvxiw8kkicgc4xig77lsa7z";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "08py6bawfrhg90fbcnv2mq4c91g5wa1q2q6zdjy2i1b9q4x1654r";
  };

  dontUnpack = true;

  LC_ALL = "en_US.UTF-8";
  nativeBuildInputs = [ graalvm8 glibcLocales ];

  buildPhase = ''
    native-image \
      -jar ${src} \
      -H:Name=bb \
      -H:+ReportExceptionStackTraces \
      -J-Dclojure.spec.skip-macros=true \
      -J-Dclojure.compiler.direct-linking=true \
      "-H:IncludeResources=BABASHKA_VERSION" \
      "-H:IncludeResources=SCI_VERSION" \
      -H:ReflectionConfigurationFiles=${reflectionJson} \
      --initialize-at-run-time=java.lang.Math\$RandomNumberGeneratorHolder \
      --initialize-at-build-time \
      -H:Log=registerResource: \
      -H:EnableURLProtocols=http,https \
      --enable-all-security-services \
      -H:+JNI \
      --verbose \
      --no-fallback \
      --no-server \
      --report-unsupported-elements-at-runtime \
      "--initialize-at-run-time=org.postgresql.sspi.SSPIClient" \
      "-J-Xmx4500m"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bb $out/bin/bb
  '';

  meta = with stdenv.lib; {
    description = "A Clojure babushka for the grey areas of Bash";
    longDescription = ''
      The main idea behind babashka is to leverage Clojure in places where you
      would be using bash otherwise.

      As one user described it:

          I’m quite at home in Bash most of the time, but there’s a substantial
          grey area of things that are too complicated to be simple in bash, but
          too simple to be worth writing a clj/s script for. Babashka really
          seems to hit the sweet spot for those cases.

    Goals:

    - Low latency Clojure scripting alternative to JVM Clojure.
    - Easy installation: grab the self-contained binary and run. No JVM needed.
    - Familiarity and portability:
      - Scripts should be compatible with JVM Clojure as much as possible
      - Scripts should be platform-independent as much as possible. Babashka
        offers support for linux, macOS and Windows.
    - Allow interop with commonly used classes like java.io.File and System
    - Multi-threading support (pmap, future, core.async)
    - Batteries included (tools.cli, cheshire, ...)
    - Library support via popular tools like the clojure CLI
    '';
    homepage = "https://github.com/borkdude/babashka";
    license = licenses.epl10;
    platforms = graalvm8.meta.platforms;
    maintainers = with maintainers; [ bandresen bhougland DerGuteMoritz jlesquembre ];
  };
}
