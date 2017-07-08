{ stdenv, fetchurl, unzip }:
let
  pname = "ttf-envy-code-r";
  version = "PR7";
in
stdenv.mkDerivation rec {
  name = "${pname}-0.${version}";

  src = fetchurl {
    url = "http://download.damieng.com/fonts/original/EnvyCodeR-${version}.zip";
    sha256 = "9f7e9703aaf21110b4e1a54d954d57d4092727546348598a5a8e8101e4597aff";
  };

  buildInputs = [unzip];

  installPhase = ''
    for f in *.ttf; do
        install -Dm 644 "$f" "$out/share/fonts/truetype/$f"
    done
    install -Dm 644 Read\ Me.txt "$out/share/doc/${pname}/readme.txt"
  '';

  meta = with stdenv.lib; {
    homepage = http://damieng.com/blog/tag/envy-code-r;
    description = "Free scalable coding font by DamienG";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = [ maintainers.lyt ];
  };
}
