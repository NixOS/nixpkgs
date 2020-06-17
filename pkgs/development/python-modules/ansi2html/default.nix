{ lib, buildPythonPackage, fetchPypi, isPy3k, six, mock, nose, setuptools }:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a9vihsvd03hb0a4dbiklyy686adp9q2ipl79mkxmdr6gfp8bbln";
  };

  propagatedBuildInputs = [ six setuptools ];

  checkInputs = [ mock nose ];

  meta = with lib; {
    description = "Convert text with ANSI color codes to HTML";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
