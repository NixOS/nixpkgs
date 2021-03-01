{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gruvbox-dark-gtk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wf4ybnjdp2kbbvz7pmqdnzk94axaqx5ws18f34hrg4y267n0w4g";
  };

  installPhase = ''
    mkdir -p $out/share/themes/gruvbox-dark
    rm -rf README.md LICENSE .github
    cp -r * $out/share/themes/gruvbox-dark
  '';

  meta = with lib; {
    description = "Gruvbox theme for GTK based desktop environments";
    homepage = "https://github.com/jmattheis/gruvbox-dark-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.nomisiv ];
  };
}
