{ lib, buildPythonPackage, fetchFromGitHub
, setuptools, pip, wheel
# , zope_testing, manuel, zope_bobo, zdaemon, zope_zc_zdaemonrecipe, zope_zc_recipe_deployment
}:

buildPythonPackage rec {
  pname = "zc_buildout";
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

  # checkInputs = [
  #   zope_testing
  #   manuel
  #   zope_bobo
  #   zdaemon
  #   #zope_zc_zdaemonrecipe # Missing package & Blocked on `zc.recipe.egg`.
  #   (zope_zc_recipe_deployment.overridePythonAttrs (oldAttrs: rec { doCheck = false; }))
  # ];
  checkPhase = ''
    $out/bin/buildout --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A software build and configuration system";
    downloadPage = "https://github.com/buildout/buildout";
    homepage = "https://www.buildout.org";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
