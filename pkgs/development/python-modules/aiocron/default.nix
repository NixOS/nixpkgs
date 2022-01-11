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
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SFRlE/ry63kB5lpk66e2U8gBBu0A7ZyjQZw9ELZVWgE=";
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
