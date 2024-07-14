{
  lib,
  buildPythonPackage,
  fetchPypi,
  lzfse,
}:
buildPythonPackage rec {
  pname = "pyliblzfse";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uwuJmzgwwC/fPb3kjqWWEYM/Nm/vg25cMs+BRRNLfT0=";
  };

  preBuild = ''
    rm -r lzfse
    ln -s ${lzfse.src} lzfse
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "liblzfse" ];

  meta = with lib; {
    description = "Python bindings for LZFSE";
    homepage = "https://github.com/ydkhatri/pyliblzfse";
    license = licenses.mit;
    maintainers = [ ];
  };
}
