{ buildPythonPackage
, fetchFromGitHub
, lib
, pip
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "zc-buildout";
  version = "3.0.0b2";

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    rev = version;
    sha256 = "01sj09xx5kmkzynhq1xd8ahn6xqybfi8lrqjqr5lr45aaxjk2pid";
  };

  propagatedBuildInputs = [
    setuptools
    pip
    wheel
  ];

  doCheck = false; # Missing package & BLOCKED on "zc.recipe.egg"

  pythonImportsCheck = [ "zc.buildout" ];

  meta = with lib; {
    description = "A software build and configuration system";
    downloadPage = "https://github.com/buildout/buildout";
    homepage = "https://www.buildout.org";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
