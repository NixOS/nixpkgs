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
    sha256 = "48546513faf2eb7901e65a64eba7b653c80106ed00ed9ca3419c3d10b6555a01";
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
