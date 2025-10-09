{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
}:
stdenv.mkDerivation {
  pname = "xannotate";
  version = "20150301-unstable-2022-06-04";

  src = fetchFromGitHub {
    owner = "blais";
    repo = "xannotate";
    rev = "66821cce888e0067f77470ddac19da1670103d1d";
    sha256 = "sha256-BDRg29ojBOFfwD4hx3XbcabwrJn2nfgI9Ld27FaQoRw=";
  };

  buildInputs = [ libX11 ];

  meta = {
    description = "Tool to scribble over X windows";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/blais/xannotate";
    mainProgram = "xannotate";
  };
}
