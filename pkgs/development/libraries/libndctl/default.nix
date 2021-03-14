{ lib, stdenv, fetchFromGitHub, autoreconfHook
, asciidoctor, pkg-config, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, json_c, kmod, which, util-linux, udev, keyutils
}:

stdenv.mkDerivation rec {
  pname = "libndctl";
  version = "70.1";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "ndctl";
    rev    = "v${version}";
    sha256 = "09ymdibcr18vpmyf2n0xrnzgccfvr7iy3p2l5lbh7cgz7djyl5wq";
  };

  outputs = [ "out" "lib" "man" "dev" ];

  nativeBuildInputs =
    [ autoreconfHook asciidoctor pkg-config xmlto docbook_xml_dtd_45 docbook_xsl libxslt
      which
    ];

  buildInputs =
    [ json_c kmod util-linux udev keyutils
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

  meta = with lib; {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage    = "https://github.com/pmem/ndctl";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
  };
}
