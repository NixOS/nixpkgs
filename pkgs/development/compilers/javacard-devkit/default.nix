{ stdenv, requireFile, unzip, makeWrapper, oraclejdk8, autoPatchelfHook
, pcsclite
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "javacard-devkit";
  version = "2.2.2";
  uscoreVersion = builtins.replaceStrings ["."] ["_"] version;

  src = requireFile {
    name = "java_card_kit-${uscoreVersion}-linux.zip";
    url = "http://www.oracle.com/technetwork/java/javasebusiness/downloads/"
        + "java-archive-downloads-javame-419430.html#java_card_kit-2.2.2-oth-JPR";
    sha256 = "1rzkw8izqq73ifvyp937wnjjc40a40drc4zsm0l1s6jyv3d7agb2";
  };

  nativeBuildInputs = [ unzip oraclejdk8 makeWrapper autoPatchelfHook ];
  buildInputs = [ pcsclite ];

  zipPrefix = "java_card_kit-${uscoreVersion}";

  sourceRoot = ".";
  unpackCmd = ''
    unzip -p "$curSrc" "$zipPrefix/$zipPrefix-rr-bin-linux-do.zip" | jar x
  '';

  installPhase = ''
    mkdir -p "$out/share/$pname"
    cp -rt "$out/share/$pname" api_export_files
    cp -rt "$out" lib

    for i in bin/*; do
      case "$i" in
        *.so) install -vD "$i" "$out/libexec/$pname/$(basename "$i")";;
        *) target="$out/bin/$(basename "$i")"
           install -vD "$i" "$target"
           sed -i -e 's|^$JAVA_HOME/bin/java|''${JAVA:-$JAVA_HOME/bin/java}|' "$target"
           wrapProgram "$target" \
             --set JAVA_HOME "$JAVA_HOME" \
             --prefix CLASSPATH : "$out/share/$pname/api_export_files"
           ;;
      esac
    done

    makeWrapper "$JAVA_HOME/bin/javac" "$out/bin/javacardc" \
      --prefix CLASSPATH : "$out/lib/api.jar"
  '';

  meta = {
    description = "Official development kit by Oracle for programming for the Java Card platform";
    longDescription = ''
      This Java Card SDK is the official SDK made available by Oracle for programming for the Java Card platform.

      Instructions for usage:

      First, compile your '.java' (NixOS-specific: you should not need to set the class path -- if you need, it's a bug):
          javacardc -source 1.5 -target 1.5 [MyJavaFile].java
      Then, test with 'jcwde' (NixOS-specific: you can change the java version used to run jcwde with eg. JAVA=jdb):
          CLASSPATH=. jcwde [MyJcwdeConfig].app & sleep 1 && apdutool [MyApdus].apdu
      Finally, convert the '.class' file into a '.cap':
          converter -applet [AppletAID] [MyApplet] [myPackage] [PackageAID] [Version]
      For more details, please refer to the documentation by Oracle
    '';
    homepage = https://www.oracle.com/technetwork/java/embedded/javacard/overview/index.html;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.ekleog ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
