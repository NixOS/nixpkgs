{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
}:

buildPythonPackage rec {
  pname = "asyncserial";
  version = "unstable-2022-06-10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "asyncserial";
    rev = "446559fec892a556876b17d17f182ae9647d5952";
    hash = "sha256-WExmgh55sTH2w7wV3i96J1F1FN7L5rX3L/Ayvt2Kw/g=";
  };

  propagatedBuildInputs = [ pyserial ];

  pythonImportsCheck = [ "asyncserial" ];

  meta = with lib; {
    description = "asyncio support for pyserial";
    homepage = "https://github.com/m-labs/asyncserial";
    license = licenses.bsd2;
    maintainers = with maintainers; [ doronbehar ];
  };
}
