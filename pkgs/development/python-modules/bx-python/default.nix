{ lib, fetchFromGitHub, buildPythonPackage, isPy27, numpy, cython, zlib, six
, python-lzo, nose }:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.8.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "v${version}";
    sha256 = "1i40vmn8n83vqcpqj843riv9vp16s753jc4wc90p0cmrnhmzcv13";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ numpy six python-lzo ];
  checkInputs = [ nose ];

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
