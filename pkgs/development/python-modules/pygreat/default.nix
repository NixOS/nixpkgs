{
  lib,
  buildPythonPackage,
  isPy3k,
  fetchFromGitHub,
  future,
  pyusb,
}:

buildPythonPackage {
  pname = "pygreat";
  version = "2019.5.1.dev0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    rev = "14c00b7c8f036f4d467e4b1a324ffa3566b126fa";
    sha256 = "1h0z83k1k4z8j36z936h61l8j3cjr3wsxr86k91v5c5h93g9dkqh";
  };

  propagatedBuildInputs = [
    future
    pyusb
  ];

  disabled = !isPy3k;

  preBuild = ''
    cd host
    substituteInPlace setup.py --replace "'backports.functools_lru_cache'" ""
    substituteInPlace pygreat/comms.py --replace "from backports.functools_lru_cache import lru_cache as memoize_with_lru_cache" "from functools import lru_cache as memoize_with_lru_cache"
    echo "$version" > ../VERSION
  '';

  meta = with lib; {
    description = "Python library for talking with libGreat devices";
    homepage = "https://greatscottgadgets.com/greatfet/";
    license = with licenses; [ bsd3 ];
  };
}
