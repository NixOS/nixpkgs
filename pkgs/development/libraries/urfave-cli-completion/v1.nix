{ lib, fetchFromGitHub }:

let
  pname = "urfave-cli-completion";
  version = "1.22.5";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "urfave";
  repo = "cli";
  rev = "v${version}";
  sha256 = "sha256-ZR3f7aFl0F9pZp/Bz2jpxhVrpkn2VnF6alg2Zc7B46o=";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    # remove shebang
    sed -i '1,2d' autocomplete/bash_autocomplete
    install -D -m 444 autocomplete/* -t $out/share/urfave-cli-complete/v1
  '';

  meta = with lib; {
    homepage = "https://github.com/urfave/cli/";
    description = "Auto-completion files for urfave/cli powered tools";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.all;
  };
}

