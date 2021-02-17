{ lib, stdenv, fetchurl, graalvm11-ce, glibcLocales }:

stdenv.mkDerivation rec {
  pname = "babashka";
  version = "0.2.10";

  reflectionJson = fetchurl {
    name = "reflection.json";
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-reflection.json";
    sha256 = "1c7f0z1hi0vcfz532r3fhr4c64jjqppf94idpa1jziz1dljkwk85";
  };

  src = fetchurl {
    url = "https://github.com/borkdude/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "0j6k3vmdljf3bjmj5dywhxjmxcs1axscc8dlnw94g5rwf9bin0dn";
  };

  dontUnpack = true;

  LC_ALL = "en_US.UTF-8";
  nativeBuildInputs = [ graalvm11-ce glibcLocales ];

  buildPhase = ''
    native-image \
      -jar ${src} \
      -H:Name=bb \
      ${lib.optionalString stdenv.isDarwin ''-H:-CheckToolchain''} \
      -H:+ReportExceptionStackTraces \
      -J-Dclojure.spec.skip-macros=true \
      -J-Dclojure.compiler.direct-linking=true \
      "-H:IncludeResources=BABASHKA_VERSION" \
      "-H:IncludeResources=SCI_VERSION" \
      -H:ReflectionConfigurationFiles=${reflectionJson} \
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
