{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, libupnpp, libnpupnp, curl, expat, libmpdclient, libmicrohttpd, jsoncpp
, makeWrapper, python3
, recoll
, mutagen
}:

let
  recoll'= recoll.override { python3Packages = python3.pkgs; };
  mutagen'= python3.pkgs.mutagen;
in

stdenv.mkDerivation rec {
  pname = "upmpdcli";
  version = "1.9.5";

  src = fetchgit {
    url = "https://framagit.org/medoc92/upmpdcli.git";
    rev = "upmpdcli-v${version}";
    sha256 = "sha256-Ai41slMaJlVnENRevelYdDIR6x4XCjh7l6IVIZbUV+s=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config libupnpp libnpupnp curl expat libmpdclient libmicrohttpd jsoncpp
    makeWrapper python3 recoll'
  ];

  enableParallelBuilding = true;

  postInstall = ''
    patchShebangs $out
    wrapProgram $out/share/upmpdcli/cdplugins/uprcl/uprcl-app.py \
      --prefix PYTHONPATH : $out/share/upmpdcli/cdplugins/uprcl:$out/share/upmpdcli/cdplugins/pycommon:${recoll'}/${python3.sitePackages}:${mutagen'}/${python3.sitePackages}
  '';

  meta = {
    description = "UPnP renderer front-end for MPD";

    license = "BSD-style";

    homepage = https://www.lesbonscomptes.com/upmpdcli;
    platforms = lib.platforms.unix;
  };
}
