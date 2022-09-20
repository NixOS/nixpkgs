{ lib, stdenv, fetchFromGitHub, libX11, libXext, makeWrapper, ncurses, cmake }:

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
  pname = "self";
  version = "2017.1";

  src = fetchFromGitHub {
    owner = "russellallen";
    repo = pname;
    rev = version;
    sha256 = "C/1Q6yFmoXx2F97xuvkm8DxFmmvuBS7uYZOxq/CRNog=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ ncurses libX11 libXext ];

  installPhase = ''
    runHook preInstall

    export original="${lib.getUnwrapped "$out/bin/Self"}"
    install -Dm755 ./vm/Self "$original"
    find ../objects -type f | xargs install -Dt "$out"/share/self
    substituteAll '${./self}' "$out/bin/Self"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A prototype-based dynamic object-oriented programming language, environment, and virtual machine";
    homepage = "https://selflanguage.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.doublec ];
    platforms = platforms.linux;
  };
}
