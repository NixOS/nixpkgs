{ stdenv
, fetchFromGitHub
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "5.4";

  repoName = "wallpapers";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1ihvv9v8m5f2n2v3bgg769l52wbg241zgp3d45q6phk7p8s1gz3s";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
    };
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/backgrounds/elementary
    cp -av *.jpg $out/share/backgrounds/elementary
  '';

  meta = with stdenv.lib; {
    description = "Collection of wallpapers for elementary";
    homepage = https://github.com/elementary/wallpapers;
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

