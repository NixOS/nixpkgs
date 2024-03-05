{ stdenv
, lib
, fetchFromGitHub
, gettext
, python3Packages
, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "deepin-gettext-tools";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-5Dd2QU6JYwuktusssNDfA7IHa6HbFcWo9sZf5PS7NtI=";
  };

  postPatch = ''
    substituteInPlace src/generate_mo.py --replace "sudo cp" "cp"
  '';

  nativeBuildInputs = [ python3Packages.wrapPython ];

  buildInputs = [
    gettext
    perlPackages.perl
    perlPackages.ConfigTiny
    perlPackages.XMLLibXML
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    wrapPythonPrograms
    wrapPythonProgramsIn "$out/lib/${pname}"
    wrapProgram $out/bin/deepin-desktop-ts-convert --set PERL5LIB $PERL5LIB
  '';

  meta = with lib; {
    description = "Translation file processing utils for DDE development";
    homepage = "https://github.com/linuxdeepin/deepin-gettext-tools";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
