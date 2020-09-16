{ lib, stdenv, fetchurl, jre, runtimeShell }:
let
  pname = "junixsocket";
  version = "2.3.4";
  src = fetchurl {
    url = "https://github.com/kohlschutter/junixsocket/releases/download/${pname}-parent-${version}/${pname}-dist-${version}-bin.tar.gz";
    sha256 = "0zmvc5ddlch1s6yd88m0wfkwpddksjlkdcg0jzn5vf6cqdds020w";
  };
  selftestjar = "${pname}-selftest-${version}-jar-with-dependencies.jar";
in
stdenv.mkDerivation {
  inherit pname;
  inherit version;
  inherit src;

  preferLocalBuild = true;
  outputs = [ "lib" "test" "out" ];

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    ''
      mkdir -p $lib/share/java
      cp lib/*.jar $lib/share/java/.
      mkdir -p $test
      cp ${selftestjar} $test/.
    '';

  doCheck = true;
  checkInputs = [ jre ];
  checkPhase = ''
      #!${runtimeShell}
      ${jre}/bin/java -jar ${selftestjar} "$@" | tee test.log
      grep -F 'Selftest PASSED' test.log
    '';

  meta = {
    description = "A Java/JNI library for using Unix Domain Sockets from Java";
    homepage = "https://github.com/kohlschutter/junixsocket";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
