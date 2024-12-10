{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
  bicpl,
  freeglut,
  mesa_glu,
  GLUT,
}:

stdenv.mkDerivation rec {
  pname = "bicgl";
  version = "unstable-2018-04-06";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "61a035751c9244fcca1edf94d6566fa2a709ce90";
    sha256 = "0lzirdi1mf4yl8srq7vjn746sbydz7h0wjh7wy8gycy6hq04qrg4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      libminc
      bicpl
      mesa_glu
    ]
    ++ lib.optionals stdenv.isDarwin [ GLUT ]
    ++ lib.optionals stdenv.isLinux [ freeglut ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DBICPL_DIR=${bicpl}/lib"
  ];

  meta = with lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Brain Imaging Centre graphics library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.hpndUc;
  };
}
