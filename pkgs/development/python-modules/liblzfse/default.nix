{ lib
, buildPythonPackage
, fetchPypi
, lzfse
}:
buildPythonPackage rec {
  pname = "pyliblzfse";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb0b899b3830c02fdf3dbde48ea59611833f366fef836e5c32cf8145134b7d3d";
  };

  preBuild = ''
    rm -r lzfse
    ln -s ${lzfse.src} lzfse
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "liblzfse"
  ];

  meta = with lib; {
    description = "Python bindings for LZFSE";
    homepage = "https://github.com/ydkhatri/pyliblzfse";
    license = licenses.mit;
    maintainers = [ ];
  };
}
