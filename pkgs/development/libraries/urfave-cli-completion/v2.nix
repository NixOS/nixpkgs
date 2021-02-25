{ lib, fetchFromGitHub }:

let
  pname = "urfave-cli-completion";
  version = "2.3.0";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "urfave";
  repo = "cli";
  rev = "v${version}";
  sha256 = "sha256-pum0HXz4bnh7x7U2KofgMoYGggSvQtB65798MNOUJcE=";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    # remove shebang
    sed -i '1,2d' autocomplete/bash_autocomplete
    install -D -m 444 autocomplete/* -t $out/share/urfave-cli-complete/v2
  '';

  meta = with lib; {
    homepage = "https://github.com/urfave/cli/";
    description = "Auto-completion files for urfave/cli powered tools";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.all;
  };
}

