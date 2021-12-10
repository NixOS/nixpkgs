{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, croniter
, tzlocal
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiocron";
  version = "1.8";

  src = fetchFromGitHub {
     owner = "gawel";
     repo = "aiocron";
     rev = "1.8";
     sha256 = "1j8x7wx0ga7g1r84xbrcm7hmw7zd42z6qhws41fdjq0g2j1lncg9";
  };

  propagatedBuildInputs = [
    croniter
    tzlocal
  ];

  checkInputs = [
    pytestCheckHook
    tzlocal
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--ignore/d" setup.cfg
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  pythonImportsCheck = [ "aiocron" ];

  meta = with lib; {
    description = "Crontabs for asyncio";
    homepage = "https://github.com/gawel/aiocron/";
    license = licenses.mit;
    maintainers = [ maintainers.starcraft66 ];
  };
}
