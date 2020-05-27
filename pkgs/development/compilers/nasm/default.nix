{ stdenv, fetchFromRepoOrCz, autoreconfHook, perl, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "nasm";
  version = "2.14.02";

  src = fetchFromRepoOrCz {
    repo = "nasm";
    rev = "${pname}-${version}";
    sha256 = "15z6ybnzlsrqs2964h6czqhpmr7vc3ln4y4h0z9vrznk4mqcwbsa";
  };

  nativeBuildInputs = [ autoreconfHook perl asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];

  postBuild = "make manpages";

  doCheck = true;

  checkPhase = ''
    make golden && make test
  '';

  NIX_CFLAGS_COMPILE="-Wno-error=attributes";

  meta = with stdenv.lib; {
    homepage = "https://www.nasm.us/";
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
    license = licenses.bsd2;
  };
}
