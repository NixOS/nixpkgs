# Temporarily avoid dependency on dotnetbuildhelpers to avoid rebuilding many times while working on it

{ stdenv, fetchurl, mono, pkgconfig, dotnetbuildhelpers, autoconf, automake, which }:

stdenv.mkDerivation rec {
  name = "fsharp-${version}";
  version = "4.0.1.1";

  src = fetchurl {
    url = "https://github.com/fsharp/fsharp/archive/${version}.tar.gz";
    sha256 = "0mvmvwwpl4zq0yvgzdizww8l9azvlrc82xm32nz1fi1nw8x5qfqk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ mono dotnetbuildhelpers autoconf automake which ];

  configurePhase = ''
    sed -i '988d' src/FSharpSource.targets
    substituteInPlace ./autogen.sh --replace "/usr/bin/env sh" "${stdenv.shell}"
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
    for dll in "$out/lib/mono/4.5"/FSharp*.dll
    do
      create-pkg-config-for-dll.sh "$out/lib/pkgconfig" "$dll"
    done
  '';

  # To fix this error when running:
  # The file "/nix/store/path/whatever.exe" is an not a valid CIL image
  dontStrip = true;

  meta = {
    description = "A functional CLI language";
    homepage = https://fsharp.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
