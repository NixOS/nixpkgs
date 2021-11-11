{ lib, pkgs, stdenv, fetchFromGitHub, jdk11_headless }:

stdenv.mkDerivation {
  pname = "lfc";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "revol-xut";
    repo = "lingua-franca-nix-releases";
    rev = "11c6d5297cd63bf0b365a68c5ca31ec80083bd05";
    sha256 = "DgxunzC8Ep0WdwChDHWgG5QJbJZ8UgQRXtP1HZqL9Jg=";
  };

  buildInputs = [ jdk11_headless ];

  _JAVA_HOME = "${jdk11_headless}/";

  postPatch = ''
    substituteInPlace bin/lfc \
      --replace 'base=`dirname $(dirname ''${abs_path})`' "base='$out'" \
      --replace "run_lfc_with_args" "${jdk11_headless}/bin/java -jar $out/lib/jars/org.lflang.lfc-0.1.0-SNAPSHOT-all.jar"
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
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ revol-xut ];
  };
}
