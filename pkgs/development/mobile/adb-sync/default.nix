{ stdenv, fetchgit, python, androidsdk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "adb-sync-${version}";
  version = "2016-08-31";

  src = fetchgit {
    url = "https://github.com/google/adb-sync";
    rev = "7fc48ad1e15129ebe34e9f89b04bfbb68ced144d";
    sha256 = "1y016bjky5sn58v91jyqfz7vw8qfqnfhb9s9jd32k8y29hy5vy4d";
  };

  buildInputs = [ python androidsdk makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/adb-channel $src/adb-sync $out/bin/
    patchShebangs $out/bin
    wrapProgram $out/bin/adb-sync --suffix PATH : ${androidsdk}/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool to synchronise files between a PC and an Android devices using ADB (Android Debug Bridge)";
    homepage = "https://github.com/google/adb-sync";
    license = licenses.asl20;
    platforms = platforms.unix;
    hydraPlatforms = [];
    maintainers = with maintainers; [ scolobb ];
  };
}
