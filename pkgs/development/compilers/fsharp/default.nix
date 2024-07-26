# Temporarily avoid dependency on dotnetbuildhelpers to avoid rebuilding many times while working on it

{ lib, stdenv, fetchFromGitHub, mono, pkg-config, dotnetbuildhelpers, autoconf, automake, which }:

stdenv.mkDerivation rec {
  pname = "fsharp";
  version = "4.0.1.1";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "fsharp";
    rev = version;
    sha256 = "sha256-dgTEM2aL8lVjVMuW0+HLc+TUA39IiuBv/RfHYNURh5s=";
  };

  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ mono dotnetbuildhelpers which ];

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
    description = "Functional CLI language";
    homepage = "https://fsharp.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice raskin ];
    platforms = with lib.platforms; unix;
  };
}
