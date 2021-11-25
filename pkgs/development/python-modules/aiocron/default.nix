{ lib
, buildPythonPackage
, fetchPypi
, python
, croniter
, tzlocal
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiocron";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rX07m9iIl5NP/RiTf/I1q5+wE1goD9QOAUYf1fdjSL0=";
  };

  propagatedBuildInputs = [
    croniter
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
