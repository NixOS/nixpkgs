{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, texinfo, pcre2
, enablePython ? false, python ? null, swig, libxml2, ncurses
}:
let
  isPython3 = enablePython && python.pythonAtLeast "3";
in
stdenv.mkDerivation rec {
  pname = "libredwg";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "LibreDWG";
    repo = pname;
    rev = version;
    sha256 = "sha256-CZZ5/uCls2tY3PKmD+hBBvp7d7KX8nZuCPf03sa4iXc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo ]
    ++ lib.optional enablePython swig;

  buildInputs = [ pcre2 ]
    ++ lib.optionals enablePython [ python ]
    # configurePhase fails with python 3 when ncurses is missing
    ++ lib.optional isPython3 ncurses
  ;

  # prevent python tests from running when not building with python
  configureFlags = lib.optional (!enablePython) "--disable-python";

  doCheck = true;

  # the "xmlsuite" test requires the libxml2 c library as well as the python module
  checkInputs = lib.optionals enablePython [ libxml2 libxml2.dev ];

  meta = with lib; {
    description = "Free implementation of the DWG file format";
    homepage = "https://savannah.gnu.org/projects/libredwg/";
    maintainers = with maintainers; [ tweber ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
