{ stdenv, fetchFromGitHub, autoreconfHook, autoconf, automake, asciidoc, docbook_xsl, docbook_xml_dtd_45, libxslt, xmlto, pkgconfig, json_c, kmod, which, systemd, utillinux
}:

let
  version = "60.3";
in stdenv.mkDerivation rec {
  name = "libndctl-${version}";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    rev = "v${version}";
    sha256 = "0w19yh6f9skf5zy4bhdjlrn3wdx5xx9cq8j6h04cmw4nla6zj9ar";
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs = [
    autoreconfHook asciidoc pkgconfig xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  buildInputs = [
    json_c kmod systemd utillinux
  ];

  preAutoreconf = ''
    substituteInPlace configure.ac --replace "which" "${which}/bin/which"
    substituteInPlace git-version --replace /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace /bin/sh ${stdenv.shell}
    echo "m4_define([GIT_VERSION], [${version}])" > version.m4;
  '';

  meta = with stdenv.lib; {
    description = "Utility library for managing the libnvdimm (non-volatile memory device) sub-system in the Linux kernel";
    homepage = https://github.com/pmem/ndctl;
    license = licenses.lgpl21;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
