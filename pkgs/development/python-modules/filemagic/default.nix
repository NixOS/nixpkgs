{ stdenv, lib, buildPythonPackage, fetchFromGitHub, file
, isPy3k, mock, unittest2 }:

buildPythonPackage {
  pname = "filemagic";
  version = "1.6";
  disabled = !isPy3k; # asserts on ResourceWarning

  # Don't use the PyPI source because it's missing files required for testing
  src = fetchFromGitHub {
    owner = "aliles";
    repo = "filemagic";
    rev = "138649062f769fb10c256e454a3e94ecfbf3017b";
    sha256 = "1jxf928jjl2v6zv8kdnfqvywdwql1zqkm1v5xn1d5w0qjcg38d4n";
  };

  postPatch = ''
    substituteInPlace magic/api.py --replace "ctypes.util.find_library('magic')" \
      "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  checkInputs = [ mock ] ++ lib.optionals (!isPy3k) [ unittest2 ];

  meta = with lib; {
    description = "File type identification using libmagic";
    homepage = "https://github.com/aliles/filemagic";
    license = licenses.asl20;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
