{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, numpy
, cython
, zlib
, python-lzo
, nose
}:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-j2GKj2IGDBk4LBnISRx6ZW/lh5VSdQBasC0gCRj0Fiw=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    numpy
    python-lzo
  ];

  nativeCheckInputs = [
    nose
  ];

  postInstall = ''
    cp -r scripts/* $out/bin

    # This is a small hack; the test suite uses the scripts which need to
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = with lib; {
    description = "Tools for manipulating biological data, particularly multiple sequence alignments";
    homepage = "https://github.com/bxlab/bx-python";
    changelog = "https://github.com/bxlab/bx-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
