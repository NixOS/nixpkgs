{ stdenv, fetchFromGitHub, autoconf, pkgconfig, gtk, libSM, shared_mime_info,
  libxml2, libxslt, docbook_xml_dtd_412 }:

stdenv.mkDerivation rec {
  name = "rox-filer-2.11";

  src = fetchFromGitHub {
    owner = "rox-desktop";
    repo = "rox-filer";
    rev = "2b9737f13900d68a2726cab6812f950157345345";
    sha256 = "0vl4c05fscpkmp7jbxy7r17jgw9rwcl6alcvljfqcc6qkpq2p6ld";
  };

  buildInputs = [ pkgconfig gtk autoconf libSM libxml2 shared_mime_info ];

  buildPhase = ''
    ./ROX-Filer/AppRun --compile

    substituteInPlace ROX-Filer/src/Docs/Makefile \
      --replace xmllint ${libxml2.bin}/bin/xmllint \
      --replace xsltproc ${libxslt.bin}/bin/xsltproc

    for xmlFile in ROX-Filer/src/Docs/Manual*.xml; do
      substituteInPlace  "$xmlFile" \
        --replace "/usr/share/sgml/docbook/dtd/xml/4.1.2/docbookx.dtd" \
                  "${docbook_xml_dtd_412}/xml/dtd/docbook/docbookx.dtd"
    done

    (cd ROX-Filer/src/Docs && make)
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/ROX-Filer,share/Choices/MIME-types,share/man/man1}
    cp -rp ROX-Filer/{Help,Messages,ROX,images} $out/share/ROX-Filer
    cp -p rox.1 $out/share/man/man1
    cp -p ROX-Filer/{AppInfo.xml,AppRun,Options.xml,ROX-Filer,Templates.ui,subclasses,style.css,.DirIcon} \
          $out/share/ROX-Filer
    cp -p Choices/MIME-types/* $out/share/Choices/MIME-types

    echo '#!/bin/sh' > $out/bin/rox
    echo "exec $out/share/ROX-Filer/AppRun \"\$@\"" >> $out/bin/rox
    chmod 755 $out/bin/rox
  '';

  meta = with stdenv.lib; {
    description = "A RISC OS-like filer for X, the file manager at the core of the ROX desktop";
    homepage = http://rox.sourceforge.net/desktop/ROX-Filer;
    platforms = platforms.linux;
    maintainers = [ maintainers.aklt ];
  };
}
