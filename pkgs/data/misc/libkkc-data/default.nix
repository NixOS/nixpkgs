{ stdenv, fetchurl, marisa, libkkc }:

stdenv.mkDerivation rec {
  pname = "libkkc-data";
  version = "0.2.7";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/releases/download/v${libkkc.version}/${name}.tar.xz";
    sha256 = "16avb50jasq2f1n9xyziky39dhlnlad0991pisk3s11hl1aqfrwy";
  };

  nativeBuildInputs = [ marisa ];

  meta = with stdenv.lib; {
    description = "Language model data package for libkkc";
    homepage    = https://github.com/ueno/libkkc;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
    platforms   = platforms.linux;
  };
}
