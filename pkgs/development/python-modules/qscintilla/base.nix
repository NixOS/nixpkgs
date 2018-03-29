{ lib
, qscintillaCpp
}: rec {
  name = "qscintilla-${version}";
  version = qscintillaCpp.version;
  format = "other";
  src = qscintillaCpp.src;

  meta = with lib; {
    description = "A Python binding to QScintilla, Qt based text editing control";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ danbst ];
    platforms = platforms.linux;
  };
}
