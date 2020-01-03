{ stdenv
, buildPythonPackage
, fetchFromGitHub
, zlib
, xz
, ncompress
, gzip
, bzip2
, gnutar
, p7zip
, cabextract
, lzma
, pycrypto
, pyqtgraph ? null }:

let visualizationSupport = (pyqtgraph != null);
in
buildPythonPackage {
  pname = "binwalk";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "devttys0";
    repo = "binwalk";
    rev = "291a03595d17f848c73b74cb6ca508da782cd8f7";
    sha256 = "0grid93yz6i6jb2zggrqncp5awdf7qi88j5y2k7dq0k9r6b8zydw";
  };

  propagatedBuildInputs = [ zlib xz ncompress gzip bzip2 gnutar p7zip cabextract lzma pycrypto ]
    ++ stdenv.lib.optional visualizationSupport pyqtgraph;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ReFirmLabs/binwalk";
    description = "A tool for searching a given binary image for embedded files";
    maintainers = [ maintainers.koral ];
  };
}
