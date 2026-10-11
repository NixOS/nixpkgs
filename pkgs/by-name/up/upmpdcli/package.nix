{
  fetchgit,
  stdenv,
  lib,
  meson,
  cmake,
  ninja,
  pkg-config,
  libupnpp,
  libnpupnp,
  curl,
  expat,
  libmpdclient,
  libmicrohttpd,
  jsoncpp,
  makeWrapper,
  python3,
  recoll,
}:

let
  mutagen' = python3.pkgs.mutagen;
in

stdenv.mkDerivation rec {
  pname = "upmpdcli";
  version = "1.9.17";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://framagit.org/medoc92/upmpdcli.git";
    rev = "upmpdcli-v${version}";
    hash = "sha256-GwQGYYI7IYrxBk7D+mHw2nUth5gkWi+nrwwASQBNlGM=";
  };

  patchPhase = ''
    sed -i -e "s@install_dir: '/etc'@install_dir: get_option('datadir') / 'etc'@" meson.build
    sed -i -e 's@''${DESTDIR}@'$out'@' tools/installconfig.sh
  '';

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
    python3
    makeWrapper
  ];

  buildInputs = [
    libupnpp
    libnpupnp
    curl
    expat
    libmpdclient
    libmicrohttpd
    jsoncpp
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  postInstall = ''
    patchShebangs $out
    wrapProgram $out/share/upmpdcli/cdplugins/uprcl/uprcl-app.py \
      --prefix PYTHONPATH : $out/share/upmpdcli/cdplugins/uprcl:$out/share/upmpdcli/cdplugins/pycommon:${recoll}/${python3.sitePackages}:${mutagen'}/${python3.sitePackages}
  '';

  meta = {
    description = "UPnP renderer front-end for MPD";

    license = "BSD-style";

    homepage = "https://www.lesbonscomptes.com/upmpdcli";
    platforms = lib.platforms.unix;
  };
}
