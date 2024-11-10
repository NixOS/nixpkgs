{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pyusb,
}:

buildPythonPackage rec {
  pname = "pygreat";
  version = "2024.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    rev = "v${version}";
    sha256 = "sha256-yYp+2y4QIOykkrObWaXbZMMc2fsRn/+tGWqySA7V534=";
  };

  propagatedBuildInputs = [
    future
    pyusb
  ];

  sourceRoot = "${src.name}/host";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  meta = with lib; {
    description = "Python library for talking with libGreat devices";
    homepage = "https://greatscottgadgets.com/greatfet/";
    license = with licenses; [ bsd3 ];
  };
}
