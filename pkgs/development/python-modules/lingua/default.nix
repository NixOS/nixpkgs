{
  lib,
  fetchPypi,
  buildPythonPackage,
  flit-core,
  polib,
  click,
}:

buildPythonPackage rec {
  pname = "lingua";
  version = "4.15.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DhqUZ0HbKIpANhrQT/OP4EvwgZg0uKu4TEtTX+2bpO8=";
  };

  postPatch = ''
    substituteInPlace src/lingua/extract.py \
      --replace-fail SafeConfigParser ConfigParser
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    polib
  ];

  pythonImportsCheck = [ "lingua" ];

  meta = with lib; {
    description = "Translation toolset";
    homepage = "https://github.com/wichert/lingua";
    license = licenses.bsd3;
    maintainers = with maintainers; [ np ];
  };
}
