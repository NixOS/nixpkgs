{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  zlib,
  xz,
}:

buildPythonPackage rec {
  pname = "deeptoolsintervals";
  version = "0.1.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fZTDb9K28Q2LmeU20mcugiiXHx/IEEl9M1J7uixA1PY=";
  };

  buildInputs = [
    zlib
    xz
  ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://deeptools.readthedocs.io/en/develop";
    description = "Helper library for deeptools";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
