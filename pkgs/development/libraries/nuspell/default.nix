{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, icu, catch2, pandoc, nuspell, testVersion }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "039ryhwfbbrrhavzyr999kngj10nk9n81i6qigxj6igfl4fzjy87";
  };

  nativeBuildInputs = [ cmake pkg-config pandoc ];
  buildInputs = [ icu ];

  outputs = [ "out" "lib" "dev" "man" ];

  postPatch = ''
    rm -rf external/Catch2
    ln -sf ${catch2.src} external/Catch2
  '';

  postInstall = ''
    rm -rf $out/share/doc
  '';

  passthru.tests.version = testVersion { package = nuspell; };

  meta = with lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
  };
}
