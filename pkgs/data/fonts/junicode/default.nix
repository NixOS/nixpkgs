{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "junicode";
  version = "1.002";

  src = fetchzip {
    url = "mirror://sourceforge/junicode/junicode/junicode-${version}/junicode-${version}.zip";
    sha256 = "1n86kxc2szdivh0nglizwdr7s8vw5pxmj6xa7fp9ql73scsrzbyn";
    stripRoot = false;
  };

  meta = {
    homepage = "http://junicode.sourceforge.net/";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
