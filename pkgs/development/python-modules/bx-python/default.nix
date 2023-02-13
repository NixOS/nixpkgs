{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, numpy, cython, zlib, six
, python-lzo, nose }:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.9.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Pi4hV3FatCXoXY3nNgqm5UfWYIrpP/v5PzzCi3gmIbE=";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ numpy six python-lzo ];
  nativeCheckInputs = [ nose ];

  postInstall = ''
    cp -r scripts/* $out/bin

    # This is a small hack; the test suit uses the scripts which need to
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = with lib; {
    homepage = "https://github.com/bxlab/bx-python";
    description =
      "Tools for manipulating biological data, particularly multiple sequence alignments";
    license = licenses.mit;
    maintainers = [ maintainers.jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
