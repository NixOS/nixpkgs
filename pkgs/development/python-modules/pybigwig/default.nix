{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, zlib
}:

buildPythonPackage rec {
  pname = "pyBigWig";
  version = "0.3.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c2a8c571b4100ad7c4c318c142eb48558646be52aaab28215a70426f5be31bc";
  };

  buildInputs = [ zlib ];

  nativeCheckInputs = [ numpy pytest ];

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
