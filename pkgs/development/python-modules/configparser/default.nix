{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "configparser";
  version = "3.5.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fi7vf09vi1588jd8f16a021m5y6ih2hy7rpbjb408xw45qb822k";
  };

  # No tests available
  doCheck = false;

  # Fix issue when used together with other namespace packages
  # https://github.com/NixOS/nixpkgs/issues/23855
  patches = [
    ./0001-namespace-fix.patch
  ];

  meta = with stdenv.lib; {
  };
}
