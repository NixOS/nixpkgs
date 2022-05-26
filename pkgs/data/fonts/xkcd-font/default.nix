{ lib, fetchFromGitHub }:

let
  pname = "xkcd-font";
  version = "unstable-2017-08-24";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "ipython";
  repo = pname;
  rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";

  postFetch = ''
    pushd $out

    install -Dm444 -t $out/share/fonts/opentype/ xkcd/build/xkcd.otf
    install -Dm444 -t $out/share/fonts/truetype/ xkcd-script/font/xkcd-script.ttf
    for f in *; do
      [[ "$f" == share ]] && continue
      rm -rf "$f"
    done

    popd
  '';
  sha256 = "sha256-oBDP4LG8csjvzSk1+EcPH6hcp44dWtPzVFSifzBq8lU=";

  meta = with lib; {
    description = "The xkcd font";
    homepage = "https://github.com/ipython/xkcd-font";
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
