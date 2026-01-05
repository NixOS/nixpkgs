{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage {
  pname = "bencoding";
  version = "0.2.6-unstable-2026-01-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dust8";
    repo = "bencoding";
    rev = "6877fa64dc513c2a10aad1cc1a957050f708a62c";
    hash = "sha256-faB4c++MfWXjj3pxMLqe/mwD+ry6/3EpZl1wZE4vyDI=";
  };

  meta = {
    description = "Bencoding is a Bcode library for Python3.";
    homepage = "https://github.com/dust8/bencoding";
    license = with lib; [
      licenses.mit
    ];
    maintainers = [
      lib.maintainers.JollyDevelopment
    ];
  };
}
