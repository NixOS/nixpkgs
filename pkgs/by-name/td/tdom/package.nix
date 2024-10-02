{
  lib,
  tcl,
  fetchzip,
  expat,
  gumbo,
  pkg-config,
}:

tcl.mkTclDerivation rec {
  pname = "tdom";
  version = "0.9.4";

  src = fetchzip {
    url = "http://tdom.org/downloads/tdom-${version}-src.tgz";
    hash = "sha256-7RvHzb4ae1HbJGkXCd68B23q/zhEK6ysYOnT6yeTLU8=";
  };

  buildInputs = [
    expat
    gumbo
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--enable-html5"
    "--with-expat=${lib.getDev expat}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = {
    description = "XML / DOM / XPath / XSLT / HTML / JSON implementation for Tcl";
    homepage = "http://www.tdom.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
