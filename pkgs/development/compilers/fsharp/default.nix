{ stdenv, fetchgit, mono, pkgconfig, autoconf, automake, which }:

stdenv.mkDerivation rec {
  name = "fsharp-${version}";
  version = "3.0";

  src = fetchgit {
    url = "https://github.com/fsharp/fsharp";
    rev = "refs/heads/fsharp_30";
    sha256 = "59639c76ff401c9ddb1af7a2f5a53a5aef4ec0d62317aeb33429f3eb009f771f";
  };

  buildInputs = [ mono pkgconfig autoconf automake which ];
  configurePhase = "./autogen.sh --prefix $out";

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
