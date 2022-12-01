{ lib
, stdenvNoCC
, coreutils
}:

{ version
, src
, patches ? [ ]
}:

stdenvNoCC.mkDerivation {
  inherit patches src version;

  pname = "fedora${lib.versions.major version}-backgrounds";

  dontBuild = true;

  postPatch = ''
    for f in default/Makefile extras/Makefile; do
      substituteInPlace $f \
        --replace "usr/share" "share" \
        --replace "/usr/bin/" "" \
        --replace "/bin/" ""
    done

    for f in $(find . -name '*.xml'); do
      substituteInPlace $f \
        --replace "/usr/share" "$out/share"
    done;
  '';

  installFlags = [
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/fedoradesign/backgrounds";
    description = "A set of default and supplemental wallpapers for Fedora";
    license = licenses.cc-by-sa-40;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
