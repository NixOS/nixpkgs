{ lib, fetchFromGitHub, python, buildPythonPackage, pytest, pkgconfig, cairo, xlibsWrapper, isPyPy }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.15.4";
  name = "${pname}-${version}";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "02vzmfxx8nl6dbwzc911wcj7hqspgqz6v9xmq6579vwfla0vaglv";
  };

  postPatch = ''
    # we are unable to pass --prefix to bdist_wheel
    # see https://github.com/NixOS/nixpkgs/pull/32034#discussion_r153285955
    substituteInPlace setup.py --replace '"prefix": self.install_base' "'prefix': '$out'"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python cairo xlibsWrapper ];
  checkInputs = [ pytest ];

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
}
