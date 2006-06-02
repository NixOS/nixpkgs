{stdenv, fetchurl}:

assert stdenv.system == "i686-cygwin";

stdenv.mkDerivation {
  # Derived from Visual C++ 2005 (= VC 8), followed by cl.exe's
  # internal version number.
  name = "visual-c++-8-14.00.50727.42";
  builder = ./builder.sh;

  # These should be downloaded eventually.
  vs8Path = "/cygdrive/c/Program Files/Microsoft Visual Studio 8";
  sdkPath = "/cygdrive/c/Program Files/Microsoft Platform SDK";
}
