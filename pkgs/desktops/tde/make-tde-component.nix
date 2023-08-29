{ lib
, fetchurl
}:

{ pname
, version
, group
, hash
}:

{
  inherit pname version;

  src = fetchurl {
    url = "mirror://tde/releases/R${version}/main/${group}/${pname}-trinity-${version}.tar.xz";
    inherit hash;
  };

  meta = {
    homepage = "https://trinitydesktop.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.tde.members;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
