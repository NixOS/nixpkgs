{ fetchurl, fetchgit, stdenv, xorg, makeWrapper, ncurses, cmake }:

stdenv.mkDerivation rec {
  # The Self wrapper stores source in $XDG_DATA_HOME/self or ~/.local/share/self 
  # so that it can be written to when using the Self transposer. Running 'Self'
  # after installation runs without an image. You can then build a Self image with:
  #   $ cd ~/.local/share/self/objects
  #   $ Self 
  #   > 'worldBuilder.self' _RunScript
  #
  # This image can later be started with:
  #   $ Self -s myimage.snap
  #
  version = "4.5.0";
  name = "self-${version}";

  src = fetchgit {
    url    = "https://github.com/russellallen/self";
    rev    = "d16bcaad3c5092dae81ad0b16d503f2a53b8ef86";
    sha256 = "966025b71542e44fc830b951f404f5721ad410ed24f7236fd0cd820ea0fc5731";
  };

  buildInputs = [ ncurses xorg.libX11 xorg.libXext makeWrapper cmake ];

  selfWrapper = ./self;

  installPhase = ''
    mkdir -p "$out"/bin
    cp ./vm/Self "$out"/bin/Self.wrapped
    mkdir -p "$out"/share/self
    cp -r ../objects "$out"/share/self/
    makeWrapper $selfWrapper $out/bin/Self \
      --set SELF_ROOT "$out"
  '';

  meta = {
    description = "A prototype-based dynamic object-oriented programming language, environment, and virtual machine";
    homepage = http://selflanguage.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = with stdenv.lib.platforms; linux;
    broken = true; # segfaults on gcc > 4.4
  };
}
