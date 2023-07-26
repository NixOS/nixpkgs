{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "go-lib";
  version = "5.8.27";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZV5zWu7UvNKVcVo79/iKMhF4H09rGyDCvEL61H05lZc=";
  };

  patches = [
    (fetchpatch {
      name = "fix_IsDir_for_symlink.patch";
      url = "https://github.com/linuxdeepin/go-lib/commit/79239904679dc70a11e1ac8e65670afcfdd7c122.patch";
      sha256 = "sha256-RsN9hK26i/W6P/+e1l1spCLdlgIEWTehhIW6POBOvW4=";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gocode/src/github.com/linuxdeepin/go-lib
    cp -a * $out/share/gocode/src/github.com/linuxdeepin/go-lib
    rm -r $out/share/gocode/src/github.com/linuxdeepin/go-lib/debian
    runHook postInstall
  '';

  meta = with lib; {
    description = "Library containing many useful go routines for things such as glib, gettext, archive, graphic, etc";
    homepage = "https://github.com/linuxdeepin/go-lib";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
