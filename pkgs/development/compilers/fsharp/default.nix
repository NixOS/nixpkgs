{ stdenv, fetchgit, mono, pkgconfig, autoconf, automake, which }:

stdenv.mkDerivation rec {
  name = "fsharp-${version}";
  version = "3.1";

  src = fetchgit {
    url = "https://github.com/fsharp/fsharp";
    rev = "refs/heads/fsharp_31";
    sha256 = "0d41ae31c57ec9ac8a4ea149b615ae085f3774b8877d8e53ddbf68856c32eda0";
  };

  buildInputs = [ mono pkgconfig autoconf automake which ];
  configurePhase = ''
    substituteInPlace ./autogen.sh "/usr/bin/env sh" "/bin/sh"
    ./autogen.sh --prefix $out
  '';

  # Make sure the executables use the right mono binary,
  # and set up some symlinks for backwards compatibility.
  postInstall = ''
    substituteInPlace $out/bin/fsharpc --replace " mono " " ${mono}/bin/mono "
    substituteInPlace $out/bin/fsharpi --replace " mono " " ${mono}/bin/mono "
    substituteInPlace $out/bin/fsharpiAnyCpu --replace " mono " " ${mono}/bin/mono "
    ln -s $out/bin/fsharpc $out/bin/fsc
    ln -s $out/bin/fsharpi $out/bin/fsi
  '';

  # To fix this error when running:
  # The file "/nix/store/path/whatever.exe" is an not a valid CIL image
  dontStrip = true;

  meta = {
    description = "A functional CLI language";
    homepage = "http://fsharp.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
