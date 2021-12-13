{ lib
, buildPythonPackage
, fetchFromGitHub
, pypemicro
, setuptools
, setuptools-scm
, setuptools-scm-git-archive
}:
buildPythonPackage rec {
  version = "1.0.6";
  pname = "pyocd-pemicro";
  doCheck = false;
  src = fetchFromGitHub {
    owner = "pyocd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i/uLE+MYGNKa3V3FudMLYMfBK9r41tu5FvzwFoa1Oag=";
  };
  buildInputs = [
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
  ];
  propagatedBuildInputs = [
    pypemicro
  ];
  meta = {
    description = "PEMicro probe plugin for pyOCD";
    longDescription = ''
      The simple PyOCD debug probe plugin for PEMicro debug probes -
      Multilink/FX, Cyclone/FX. The purpose of this plugin is keep separately
      this support because is using PyPemicro package which is designed for
      Python 3.x without backward compatibility for Python2.x. The PyOCD use
      this support only with Python 3.x and higher, for Python 2.x the PeMicro
      won't be supported.
    '';
    homepage = "https://github.com/pyocd/pyocd-pemicro";
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.theotherjimmy ];
  };
}
