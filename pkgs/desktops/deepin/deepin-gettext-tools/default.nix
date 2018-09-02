{ stdenv, fetchFromGitHub, gettext, python3Packages, perlPackages }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-gettext-tools";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "03cwa82dd14a31v44jd3z0kpiri6g21ar4f48s8ph78nvjy55880";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];

  buildInputs = [
    gettext
    perlPackages.perl
    perlPackages.XMLLibXML
    perlPackages.ConfigTiny
    python3Packages.python
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -e 's/sudo cp/cp/' -i src/generate_mo.py
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapPythonProgramsIn "$out/lib/${pname}"
    wrapProgram $out/bin/deepin-desktop-ts-convert --set PERL5LIB $PERL5LIB
  '';

  meta = with stdenv.lib; {
    description = "Deepin Internationalization utilities";
    homepage = https://github.com/linuxdeepin/deepin-gettext-tools;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
