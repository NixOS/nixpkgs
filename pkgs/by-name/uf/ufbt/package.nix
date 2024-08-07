{ lib, stdenv, buildPythonPackage, fetchPypi, makeWrapper, setuptools, setuptools-git-versioning, flipperzero-toolchain }:

buildPythonPackage rec {
  pname = "ufbt";
  version = "0.2.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zxxiklijx9r4557iw6qnf1vhdzavs3i1rba4w9a4pzr56jkq0m5";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ setuptools setuptools-git-versioning ];

  postInstall = ''
    wrapProgram $out/bin/ufbt \
      --set FBT_TOOLCHAIN_PATH ${flipperzero-toolchain}/opt/flipperzero-toolchain
  '';

  meta = with lib;
    {
      description = "uFBT is a cross-platform tool for building applications for Flipper Zero. It is a simplified version of Flipper Build Tool (FBT).";
      mainProgram = "ufbt";
      homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
      license = licenses.gpl3;
      maintainers = with maintainers; [ CodeRadu ];
      platforms = platforms.linux;
    };
}
