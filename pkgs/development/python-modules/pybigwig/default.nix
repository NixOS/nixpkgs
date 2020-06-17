{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, zlib
}:

buildPythonPackage rec {
  pname = "pyBigWig";
  version = "0.3.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "157x6v48y299zm382krf1dw08fdxg95im8lnabhp5vc94s04zxj1";
  };

  buildInputs = [ zlib ];

  checkInputs = [ numpy pytest ];

  meta = with lib; {
    homepage = "https://github.com/deeptools/pyBigWig";
    description = "File access to bigBed files, and read and write access to bigWig files";
    longDescription = ''
      A python extension, written in C, for quick access to bigBed files
      and access to and creation of bigWig files. This extension uses
      libBigWig for local and remote file access.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
