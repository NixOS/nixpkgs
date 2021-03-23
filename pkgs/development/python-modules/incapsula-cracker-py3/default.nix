{ lib, buildPythonPackage, fetchPypi, beautifulsoup4, requests, six }:

buildPythonPackage rec {
  pname = "incapsula-cracker-py3";
  version = "0.1.8.1";

  src = fetchPypi {
      inherit pname version;
      sha256 = "60079f6602a3e4ef21d68e7bc99b52e378ae1d0e55135b05de01a241d71d1fe7";
  };

  propagatedBuildInputs = [ beautifulsoup4 requests six ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Bypass sites guarded with Incapsula";
    homepage = "https://github.com/ziplokk1/incapsula-cracker-py3";
    license = licenses.unlicense;
  };
}
