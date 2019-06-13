{ stdenv, fetchFromGitHub, autoreconfHook
, asciidoctor, pkgconfig, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, json_c, kmod, which, file, utillinux, systemd, keyutils
}:

stdenv.mkDerivation rec {
  name = "libndctl-${version}";
  version = "65";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "ndctl";
    rev    = "v${version}";
    sha256 = "0d8hzfvyxs2q8kgkwgdizlml41kin4mhx3vpdsjk34pfi7mqy69y";
  };

  outputs = [ "out" "lib" "man" "dev" ];

  nativeBuildInputs =
    [ autoreconfHook asciidoctor pkgconfig xmlto docbook_xml_dtd_45 docbook_xsl libxslt
      which
    ];

  buildInputs =
    [ json_c kmod utillinux systemd keyutils
    ];

  configureFlags =
    [ "--without-bash"
      "--without-systemd"
    ];

  patchPhase = ''
    patchShebangs test

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
