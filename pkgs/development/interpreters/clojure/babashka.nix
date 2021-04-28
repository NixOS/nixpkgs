{ lib, stdenv, fetchurl, graalvm11-ce, glibcLocales }:

stdenv.mkDerivation rec {
  pname = "babashka";
  version = "0.3.5";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://github.com/babashka/${pname}/releases/download/v${version}/${pname}-${version}-reflection.json";
    sha256 = "sha256-TVFdGFXclJE9GpolKzTGSmeianBdb2Yp3kbNUWlddPw=";
  };

  src = fetchurl {
    url = "https://github.com/babashka/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-tOLT5W5kK38fb9XL9jOQpw0LjHPjbn+BarckbCuwQAc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ graalvm11-ce glibcLocales ];

  LC_ALL = "en_US.UTF-8";
  BABASHKA_JAR = src;
  BABASHKA_BINARY = "bb";
  BABASHKA_XMX = "-J-Xmx4500m";

  buildPhase = ''
    runHook preBuild

    # https://github.com/babashka/babashka/blob/77daea7362d8e2562c89c315b1fbcefde6fa56a5/script/compile
    args=("-jar" "$BABASHKA_JAR"
          "-H:Name=$BABASHKA_BINARY"
          "${lib.optionalString stdenv.isDarwin ''-H:-CheckToolchain''}"
          "-H:+ReportExceptionStackTraces"
          "-J-Dclojure.spec.skip-macros=true"
          "-J-Dclojure.compiler.direct-linking=true"
          "-H:IncludeResources=BABASHKA_VERSION"
          "-H:IncludeResources=SCI_VERSION"
          "-H:ReflectionConfigurationFiles=${reflectionJson}"
          "--initialize-at-build-time"
          # "-H:+PrintAnalysisCallTree"
          # "-H:+DashboardAll"
          # "-H:DashboardDump=reports/dump"
          # "-H:+DashboardPretty"
          # "-H:+DashboardJson"
          "-H:Log=registerResource:"
          "-H:EnableURLProtocols=http,https,jar"
          "--enable-all-security-services"
          "-H:+JNI"
          "--verbose"
          "--no-fallback"
          "--no-server"
          "--report-unsupported-elements-at-runtime"
          "--initialize-at-run-time=org.postgresql.sspi.SSPIClient"
          "--native-image-info"
          "--verbose"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.MixerProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.FormatConversionProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileWriter"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiDeviceProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.SoundbankReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileWriter"
          "$BABASHKA_XMX")

     native-image ''${args[@]}

     runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bb $out/bin/bb

    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/bb --version | grep '${version}'
    $out/bin/bb '(+ 1 2)' | grep '3'
    $out/bin/bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]' | grep '[1 2]'
  '';

  meta = with lib; {
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
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ bandresen bhougland DerGuteMoritz jlesquembre ];
  };
}
