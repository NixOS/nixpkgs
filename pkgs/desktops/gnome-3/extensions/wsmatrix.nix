{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-wsmatrix-${version}";
  version = "9543a73df7bac9476f8adeba9d7a14fdacb57b7d";

  src = fetchFromGitHub {
    owner = "mzur";
    repo = "gnome-shell-wsmatrix";
    rev = version;
    sha256 = "0x5y91pj2pg25pq3a2p05lsyafyg950b4nc1zc5glmsc7s42zzkw";
  };

  buildInputs = [
    glib
  ];

  buildPhase = ''
    make schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/${uuid}
  '';

  uuid = "wsmatrix@martin.zurowietz.de";

  meta = with stdenv.lib; {
    description = "Arranges workspaces in a configurable grid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ deepfire ];
    homepage = https://github.com/mzur/gnome-shell-wsmatrix;
  };
}
