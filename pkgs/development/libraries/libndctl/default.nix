{ stdenv, fetchFromGitHub, autoreconfHook
, asciidoctor, pkgconfig, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, json_c, kmod, which, utillinux, systemd, keyutils
}:

stdenv.mkDerivation rec {
  pname = "libndctl";
  version = "67";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "ndctl";
    rev    = "v${version}";
    sha256 = "076jgw1g2aafqgnq705in0wnabysqk46dq5yxdv1qzgjmyhka39n";
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
