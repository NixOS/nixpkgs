{ stdenv, fetchurl, jdk, glib, xulrunner, zip, pkgconfig, perl, npapi_sdk, bash, bc, git }:
let

cveFixes = fetchurl {
  # CVE-2019-10185: zip-slip attack during auto-extraction of a JAR file.
  # CVE-2019-10181: executable code could be injected in a JAR file without
  #                 compromising the signature verification.
  # CVE-2019-10182: improper path sanitization from elements in JNLP
  #                  files.
  url = "https://patch-diff.githubusercontent.com/raw/AdoptOpenJDK/IcedTea-Web/pull/346.patch";
  sha256 = "1lzwib5affz9nm3iyd0ij33km9k8ny9r6p9429zlgxfq4s6jdrqc";
};

in

stdenv.mkDerivation rec {
  name = "icedtea-web-${version}";

  version = "1.7.2";

  src = fetchurl {
    url = "http://icedtea.wildebeest.org/download/source/${name}.tar.gz";
    sha256 = "1gsgcf2h25kg12d4mzsw0kaf3i72bfqkr8vi70d0yq9lqinrfkl2";
  };

  nativeBuildInputs = [ pkgconfig bc perl ];
  buildInputs = [ glib xulrunner zip npapi_sdk ];

  postPatch = ''
    # The patch includes binary blobs for tests so we must use `git apply`
    # directly instead of relying on `git patch` from `patchPhase`
    ${git}/bin/git apply --verbose --exclude=ChangeLog ${cveFixes}
  '';

  postInstall = ''
    mv $out/bin/itweb-settings{.sh,}
    mv $out/bin/javaws{.sh,}
    mv $out/bin/policyeditor{.sh,}
  '';

  preConfigure = ''
    configureFlagsArray+=("BIN_BASH=${bash}/bin/bash")
  '';

  configureFlags = [
    "--with-jdk-home=${jdk.home}"
    "--disable-docs"
  ];

  mozillaPlugin = "/lib";

  meta = {
    description = "Java web browser plugin and an implementation of Java Web Start";
    longDescription = ''
      A Free Software web browser plugin running applets written in the Java
      programming language and an implementation of Java Web Start, originally
      based on the NetX project.
    '';
    homepage = http://icedtea.classpath.org/wiki/IcedTea-Web;
    maintainers = with stdenv.lib.maintainers; [ wizeman ];
    platforms = stdenv.lib.platforms.linux;
  };
}
