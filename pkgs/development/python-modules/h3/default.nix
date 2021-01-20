{ lib, stdenv
, buildPythonPackage
, cmake
, fetchPypi
, h3
, python
}:

buildPythonPackage rec {
  pname = "h3";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd27fc8ecd9183f93934079b7c986401f499030ff2e2171eace9de462fab561d";
  };

  patches = [
    ./disable-custom-install.patch
    ./hardcode-h3-path.patch
  ];

  preBuild = ''
    substituteInPlace h3/h3.py \
      --subst-var-by libh3_path ${h3}/lib/libh3${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    homepage = "https://github.com/uber/h3-py";
    description = "This library provides Python bindings for the H3 Core Library.";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = [ maintainers.kalbasit ];
  };
}
