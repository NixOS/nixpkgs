{ lib, stdenv, fetchFromGitLab, autoreconfHook, boost, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "mdds";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = pname;
    rev = version;
    sha256 = "sha256-jCzF0REocpnP56LfY42zlGTXyKyz4GPovDshhrh4jyo=";
  };

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];
  nativeBuildInputs = [ autoreconfHook ];

  checkInputs = [ boost ];

  meta = with lib; {
    homepage = "https://gitlab.com/mdds/mdds";
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
