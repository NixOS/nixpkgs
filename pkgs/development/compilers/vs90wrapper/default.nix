{stdenv}:

stdenv.mkDerivation {
  name = "visual-studio-9.0";
  buildCommand = ''
    ensureDir $out/bin
    ln -s "/cygdrive/c/Program Files/Microsoft Visual Studio 9.0/VC/vcpackages/vcbuild.exe" $out/bin/vcbuild.exe
  '';
}
