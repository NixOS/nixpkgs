{ stdenv, fetchFromGitHub, autoreconfHook
, asciidoctor, pkgconfig, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, json_c, kmod, which, file, utillinux, systemd
}:

stdenv.mkDerivation rec {
  name = "libndctl-${version}";
  version = "63";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "ndctl";
    rev    = "v${version}";
    sha256 = "060nsza8xic769bxj3pvl70a9885bwrc0myw16l095i3z6w7yzwq";
  };

  outputs = [ "out" "lib" "man" "dev" ];

  nativeBuildInputs =
    [ autoreconfHook asciidoctor pkgconfig xmlto docbook_xml_dtd_45 docbook_xsl libxslt
    ];

  buildInputs =
    [ json_c kmod utillinux systemd
    ];

  configureFlags =
    [ "--without-bash"
      "--without-systemd"
    ];

  patchPhase = ''
    patchShebangs test
    substituteInPlace configure.ac --replace "which" "${which}/bin/which"

    substituteInPlace git-version --replace /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace /bin/sh ${stdenv.shell}

    echo "m4_define([GIT_VERSION], [${version}])" > version.m4;
  '';

  meta = with stdenv.lib; {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage    = https://github.com/pmem/ndctl;
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
  };
}
