{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, asciidoc, docbook_xsl, docbook_xml_dtd_45, libxslt, xmlto, pkgconfig, json_c, kmod, which, systemd, utillinux
}:

let
  version = "61.2";
in stdenv.mkDerivation rec {
  name = "libndctl-${version}";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    rev = "v${version}";
    sha256 = "0vid78jzhmzh505bpwn8mvlamfhcvl6rlfjc29y4yn7zslpydxl7";
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs = [
    autoreconfHook asciidoc pkgconfig xmlto docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  buildInputs = [
    json_c kmod systemd utillinux
  ];

  patches = [
    (fetchpatch {
      name = "add-missing-include-for-ssize_t.patch";
      url = "https://github.com/pmem/ndctl/commit/8f1798d14dda367c659b87362edb312739830ddf.patch";
      sha256 = "1jr5kh087938msl22hgjngbf025n9iplz0czmybfp7lavl73m0pm";
    })
  ];

  postPatch = ''
    patchShebangs test
  '';

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
