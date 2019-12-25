{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "5.5.0";

  repoName = "wallpapers";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0c63nds2ylqgcp39s13mfwhipgyw8cirn0bhybp291l5g86ii6s3";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Collection of wallpapers for elementary";
    homepage = https://github.com/elementary/wallpapers;
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

