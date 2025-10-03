{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  pyserial,
  asyncserial,
  jinja2,
  migen,

  # tests
  numpy,
}:

buildPythonPackage {
  pname = "misoc";
  version = "0.12-unstable-2024-05-14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "misoc";
    rev = "fea9de558c730bc394a5936094ae95bb9d6fa726";
    hash = "sha256-zZ9LnUwvTvBL9iNFfmNTklQnd0I4PmV0BApMSblTnc0=";
  };

  dependencies = [
    pyserial
    asyncserial
    jinja2
    migen
  ];

  nativeCheckInputs = [ numpy ];

  pythonImportsCheck = [ "misoc" ];

  meta = {
    description = "Original high performance and small footprint system-on-chip based on Migen";
    homepage = "https://github.com/m-labs/misoc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
