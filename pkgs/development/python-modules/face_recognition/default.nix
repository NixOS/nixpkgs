{ buildPythonPackage, fetchFromGitHub, pillow, click, dlib, numpy
, face_recognition_models, scipy, stdenv, flake8, tox, pytest, glibcLocales
}:

buildPythonPackage rec {
  pname = "face_recognition";
  version = "1.2.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "ageitgey";
    rev = "fe421d4acd76e8a19098e942b7bd9c3bbef6ebc4"; # no tags available in Git, pure revs are pushed to pypi
    sha256 = "0wv5qxkg7xv1cr43zhhbixaqgj08xw2l7yvwl8g3fb2kdxyndw1c";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "flake8==2.6.0" "flake8"
  '';

  propagatedBuildInputs = [ pillow click dlib numpy face_recognition_models scipy ];

  checkInputs = [ flake8 tox pytest glibcLocales ];
  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://github.com/ageitgey/face_recognition;
    maintainers = with maintainers; [ ma27 ];
    description = "The world's simplest facial recognition api for Python and the command line";
  };
}
