{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  systemd,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemd-bootchart";
  version = "235";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-bootchart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1h6/Q6ShfJbu/DXENIe5GAQiZp4jlOAg6SAR36cmg2I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
  ];

  buildInputs = [
    systemd
  ];

  configureFlags = [
    "--with-rootprefix=$(out)"
  ];

  meta = {
    description = "Boot performance graphing tool from systemd";
    homepage = "https://github.com/systemd/systemd-bootchart";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
})
