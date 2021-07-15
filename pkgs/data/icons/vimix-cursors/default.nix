{ stdenv, fetchFromGitHub, fetchpatch, xcursorgen, python3Packages, bash }:

stdenv.mkDerivation rec {
  pname = "vimix-cursors";
  version = "2020-02-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Vimix-cursors";
    rev = version;
    sha256 = "0bij0x916lbxph28i3d4hz5l6mzk5fa68mf21jnl7y9rpxx07xsd";
  };

  nativeBuildInputs = [ python3Packages.cairosvg xcursorgen ];

  patches = [
    (fetchpatch {
      url = "https://github.com/vinceliuice/Vimix-cursors/commit/b39d0b41e296cdd0c540078aeda72e9711f0406e.patch";
      sha256 = "1gh4prb8n5i5njdifgz71pgj4nw45xc23iggnlf9r5n1y3n0w6vc";
    })
    (fetchpatch {
      url = "https://github.com/vinceliuice/Vimix-cursors/commit/a4e5d9d98e855db903629cf9ff9e56138d0aef96.patch";
      sha256 = "1wcz6m3jjzx47qh6m571bn6fpbqqc7kmxd0j8iimj850gavip28w";
    })
    (fetchpatch {
      url = "https://github.com/vinceliuice/Vimix-cursors/commit/89d75d3d942a07c90b04404bb8dd5a346e2261fe.patch";
      sha256 = "0qklgdhsp1lvscx1kf0rgqa7k2h5fiwgjkyj44mq6vkr0770zlb9";
    })
    (fetchpatch {
      url = "https://github.com/vinceliuice/Vimix-cursors/commit/bc42481f3a7b412c8ef792fac39af560c6064f99.patch";
      sha256 = "1gx7gqnbq0xphbm8g68b7skiwsjxsca07n1w986b24bywv0f1kav";
    })
    (fetchpatch {
      url = "https://github.com/vinceliuice/Vimix-cursors/commit/bcc7a56c2b02ee1a13214e654f97fb7ec2d5b7d9.patch";
      sha256 = "1fp4qqy925c2i4zjka23hi506f2f3naq9v5jnnd93fzyzmfyq47h";
    })
  ];

  buildPhase = ''
    HOME=$TMP ${bash}/bin/bash ./build.sh
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dist $out/share/icons/Vimix-cursors
    cp -pr dist-white $out/share/icons/Vimix-cursors-white
  '';

  meta = with stdenv.lib; {
    description = "Vimix cursors";
    homepage = "https://github.com/vinceliuice/Vimix-cursors";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
