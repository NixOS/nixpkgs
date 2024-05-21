{ lib, pkgs, stdenv, fetchzip, jdk17_headless }:

stdenv.mkDerivation rec {
  pname = "lfc";
  version = "0.4.0";

  src = fetchzip {
    url = "https://github.com/lf-lang/lingua-franca/releases/download/v${version}/lf-cli-${version}.zip";
    sha256 = "sha256-LrAm77iPUlqVfRdYy2bZ4mim7DHIr5JxPdbrgxokGvc=";
  };

  buildInputs = [ jdk17_headless ];

  _JAVA_HOME = "${jdk17_headless}/";

  postPatch = ''
    substituteInPlace bin/lfc \
      --replace 'base=`dirname $(dirname ''${abs_path})`' "base='$out'" \
      --replace "run_lfc_with_args" "${jdk17_headless}/bin/java -jar $out/lib/jars/org.lflang.lfc-${version}-all.jar"
  '';

  installPhase = ''
    cp -r ./ $out/
    chmod +x $out/bin/lfc
  '';

  meta = with lib; {
    description = "Polyglot coordination language";
    longDescription = ''
      Lingua Franca (LF) is a polyglot coordination language for concurrent
      and possibly time-sensitive applications ranging from low-level
      embedded code to distributed cloud and edge applications.
    '';
    homepage = "https://github.com/lf-lang/lingua-franca";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ revol-xut ];
  };
}
