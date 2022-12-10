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

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  checkInputs = [ boost ];

  meta = with lib; {
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    homepage = "https://gitlab.com/mdds/mdds";
    maintainers = [];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
