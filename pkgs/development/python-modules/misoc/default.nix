{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  asyncserial,
  jinja2,
  migen,
  numpy,
}:

buildPythonPackage rec {
  pname = "misoc";
  version = "unstable-2022-10-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "misoc";
    rev = "6a7c670ab6120b8136f652c41d907eb0fb16ed54";
    hash = "sha256-dLDp0xg5y5b443hD7vbJFobHxbhtnj68RdZnQ7ckgp4=";
  };

  propagatedBuildInputs = [
    pyserial
    asyncserial
    jinja2
    migen
  ];

  nativeCheckInputs = [ numpy ];

  pythonImportsCheck = [ "misoc" ];

  meta = with lib; {
    description = "Original high performance and small footprint system-on-chip based on Migen";
    homepage = "https://github.com/m-labs/misoc";
    license = licenses.bsd2;
    maintainers = with maintainers; [ doronbehar ];
  };
}
