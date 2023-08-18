{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, numpy
, moderngl
, pyglet
, pillow
, pyrr
, glcontext
}:

buildPythonPackage rec {
  pname = "moderngl-window";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "moderngl";
    repo = "moderngl_window";
    rev = "refs/tags/${version}";
    hash = "sha256-mg3j5ZoMwdk39L5xjcoEJo9buqssM1VLJtndSFsuCB0=";
  };

  propagatedBuildInputs = [ numpy moderngl pyglet pillow pyrr glcontext ];

  disabled = !isPy3k;

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [ "moderngl_window" ];

  meta = with lib; {
    description = "Cross platform helper library for ModernGL making window creation and resource loading simple";
    homepage = "https://github.com/moderngl/moderngl-window";
    changelog = "https://github.com/moderngl/moderngl-window/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    platforms = platforms.mesaPlatforms;
    broken = stdenv.isDarwin; # darwin build breaks
  };
}
