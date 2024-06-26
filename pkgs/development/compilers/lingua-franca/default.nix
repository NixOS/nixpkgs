{ lib, pkgs, stdenv, jdk17_headless }:

stdenv.mkDerivation rec {
  pname = "lfc";
  version = "0.5.1";

  src = builtins.fetchTarball {
    url = "https://github.com/lf-lang/lingua-franca/releases/download/v${version}/lf-cli-${version}-Linux-x86_64.tar.gz";
    sha256 = "110kph2di59wj32gx4ymh4237dvyd9m2daamnyxck89vw7la9sjp";
  };

  buildInputs = [ jdk17_headless ];

  _JAVA_HOME = "${jdk17_headless}/";

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
    homepage = "https://lf-lang.org";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ revol-xut ];
  };
}
