{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qmarkdowntextedit";
  version = "unstable-2022-06-30";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = pname;
    rev = "3e52e20881d262c93b532641127c060267a500fe";
    sha256 = "sha256-cvePq1X/Tq6ob762qjuYmoa8XNtVOiFTy/nbeXIih0w";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  qmakeFlags = [
    "qmarkdowntextedit-lib.pro"
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  patches = [
    (fetchpatch {
      name = "install_trans_by_qmake";
      url = "https://github.com/pbek/qmarkdowntextedit/commit/3e3992dcdc03a997dbb9b0634368c3feb7af0a17.patch";
      sha256 = "sha256-6on53YnmUwoAAg48rwT64PCvvLo9ooU2Vlh9bOjvZzw";
    })
    (fetchpatch {
      name = "Generate_pkgconfig_file_by_qmake";
      url = "https://github.com/pbek/qmarkdowntextedit/commit/025153d3ab565ba071ffe79212d7befae3db2ba1.patch";
      sha256 = "sha256-FfTmlQl1Hn8edtbaj8Gsu3hBRB4ebah6Z+YDZ0cwVac=";
    })
  ];

  meta = with lib; {
    description = "C++ Qt QPlainTextEdit widget with markdown highlighting and some other goodies";
    homepage = "https://github.com/pbek/qmarkdowntextedit";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
