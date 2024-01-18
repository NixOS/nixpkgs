{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncio-rlock";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "asyncio_rlock";
    inherit version;
    sha256 = "7e29824331619873e10d5d99dcc46d7b8f196c4a11b203f4eeccc0c091039d43";
  };

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "asyncio_rlock" ];

  meta = with lib; {
    description = "Rlock like in threading module but for asyncio";
    homepage = "https://gitlab.com/heckad/asyncio_rlock";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
